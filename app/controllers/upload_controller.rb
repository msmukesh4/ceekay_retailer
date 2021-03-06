require 'rubyXL'
class UploadController < ApplicationController

	before_action :confirm_logged_in
	layout "application"


	def index
		@presign_upload_path = S3Manager.presign("ceekay.xlsx", 30.megabyte)
		puts "url in index: #{@presign_upload_path}"
		respond_to do |format|
			format.html
		end
	end

	def create

		Delayed::Job.enqueue UploadExcelToDb.new()
		flash[:notice] = "File being uploaded, Kindly wait"
		upload = Upload.new
		upload.file_name = "ceekay.xlxs"
		upload.path = "#{Rails.public_path}/ceekay.xlsx"
		upload.save
		redirect_to(:controller => 'retailer', :action => 'index')

	end

	def new
		
	end

end

class UploadExcelToDb

  	def perform
	    row_number = -1
		@user_count = 0
		new_retailers_list = []
		
		S3Manager.fetchFileFromS3("ceekay.xlsx")
        workbook = RubyXL::Parser.parse("#{Rails.public_path}/ceekay.xlsx")
		worksheet = workbook[0]
		# parsing the rows of excel sheet
		worksheet.each { |row|

		  	if row_number >= 0
		  		r_code = row.cells[0] && row.cells[0].value
		  		if r_code.blank? 
		  			break
		  		end
		  		r_name = row.cells[1] && row.cells[1].value
		  		branch_code = row.cells[2] && row.cells[2].value
		  		dse = row.cells[3] && row.cells[3].value
		  		dse = dse.to_s
		  		r_route_no = row.cells[4] && row.cells[4].value

				puts "Details :  dse : #{dse} | rcode = #{r_code} | r_name = #{r_name} | branch : #{branch_code}|r_route_no = #{r_route_no.to_i}"
				new_retailers_list.push(r_code)
		  		retailer = Retailer.where(:retailer_code => r_code, :branch_code => branch_code).first

		  		# retailer not found
		  		if retailer.blank?
		  			retailer = Retailer.new
		  		end
			   
			    retailer.retailer_code = r_code
			    retailer.retailer_name = r_name
			    retailer.branch_code = branch_code
			    retailer.dse_code = dse
			    retailer.route_no = r_route_no.to_i.to_s
			    retailer.is_active = true

			    usr = User.where(:dse_code => dse.to_s).first
			    puts usr.inspect
			    if !usr
			    	puts "DSE code not allocated to any user : #{dse}"
			    	a = ApplicationController.new
			    	u = User.new
			    	u.dse_code = dse
			    	u.email = dse
			    	u.password = a.encrypt(dse)
			    	u.access_token = SecureRandom.hex(10)
			    	if u.save
			    		@user_count += 1
			    	else
			    		puts "User with dse code #{dse} not saved"
			    	end
			    else
			    	puts "DSE code allocated to user #{usr.id}"
			    end
			    retailer.save
			    puts retailer.inspect
		  	end
		  	row_number += 1
		  	puts row_number
		  	if (row_number%50 == 0)
		  		puts "running garbage collector"
		  		GC.start
		  	end
		  	if (row_number%200 == 0)
		  		lastUpload = Upload.last
				lastUpload.records_added = row_number
				lastUpload.save
				puts "updated databse with record entries update : #{lastUpload.records_added}"
				puts "row count :"+row_number.to_s

		  	end
		}
		deactivateOldEntries(new_retailers_list)
		lastUpload = Upload.last
		lastUpload.is_completed = true
		lastUpload.save
		puts Upload.last
		puts "#{row_number } rows inserted"

  	end


	def deactivateOldEntries(new_retailers_list)
		retailer = Retailer.where('retailer_code NOT IN (?)', new_retailers_list)
				puts "All old retailers list"+retailer.inspect

		retailer.update_all( {:is_active => false})
	end
end
