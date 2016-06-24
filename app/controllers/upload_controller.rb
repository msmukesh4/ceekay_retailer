require 'rubyXL'
class UploadController < ApplicationController

	before_action :confirm_logged_in

	# def export_xls_to_db(path)
	# 	row_number = -1
	# 	@user_count = 0
	# 	new_retailers_list = []
	# 	puts "path : #{Rails.public_path}/uploads/ck_retailers.xlsx"
	# 	workbook = RubyXL::Parser.parse("#{Rails.public_path}/uploads/ck_retailers.xlsx")

	# 	worksheet = workbook[0]

	# 	# parsing the rows of excel sheet
	# 	worksheet.each { |row|
		  
	# 	  	if row_number >= 0

	# 	  		r_code = row.cells[0] && row.cells[0].value
	# 	  		if r_code.blank? 
	# 	  			break
	# 	  		end
	# 	  		r_name = row.cells[1] && row.cells[1].value
	# 	  		dse = row.cells[2] && row.cells[2].value
	# 	  		r_route_no = row.cells[3] && row.cells[3].value

	# 	  		puts "Details :  dse : #{dse} | rcode = #{r_code} | r_name = #{r_name} | r_route_no = #{r_route_no.to_i}"

	# 			new_retailers_list.push(r_code)
	# 	  		retailer = Retailer.where(:retailer_code => r_code).first

	# 	  		# retailer not found
	# 	  		if retailer.blank?
	# 	  			retailer = Retailer.new
	# 	  		end
			   
	# 		    retailer.retailer_code = r_code
	# 		    retailer.retailer_name = r_name
	# 		    retailer.dse_code = dse
	# 		    retailer.route_no = r_route_no.to_i.to_s
	# 		    retailer.is_active = true

	# 		    usr = User.where(:dse_code => dse).first
	# 		    puts usr.inspect
	# 		    if !usr
	# 		    	puts "DSE code not allocated to any user : #{dse}"
	# 		    	u = User.new
	# 		    	u.dse_code = dse
	# 		    	u.email = dse
	# 		    	u.password = encrypt(dse)
	# 		    	u.access_token = SecureRandom.hex(10)
	# 		    	if u.save
	# 		    		@user_count += 1
	# 		    	else
	# 		    		puts "User with dse code #{dse} not saved"
	# 		    	end
	# 		    else
	# 		    	puts "DSE code allocated to user #{usr.id}"
	# 		    end
	# 		    retailer.save
	# 		    puts retailer.inspect
	# 	  	end
	# 	  	row_number += 1
	# 	  	puts row_number
	# 	}
	# 	deactivateOldEntries(new_retailers_list)
	# 	upload.last.is_completed = true
	# 	upload.last.save
	# 	puts upload.last
	# 	puts "#{row_number } rows inserted"
	# 	return row_number
	# end
	# handle_asynchronously :export_xls_to_db

	def index
		# if !Upload.last.blank?
		# 	flash[:notice] = "one excel file already uploaded"
		# 	redirect_to(:controller => 'retailer', :action => 'index')
		# end
	end

	def create
		begin
			name = params[:upload][:file].original_filename
			ext = name.split(".").last
		    puts "name : #{name}, ext : #{ext}"
		    if ext == "xlsx" or ext == "xls"
		    	directory = "#{Rails.public_path}/uploads"
			    path = File.join(directory, "/ck_retailers.xlsx")
			   
			    # if Upload.last.blank?
			    Delayed::Job.enqueue UploadExcelToDb.new(path, params[:upload][:file])
				# rows = export_xls_to_db(path)
				 # rows = perform(path)
			    upload = Upload.new
			    upload.file_name = name
			    upload.path = directory
			    upload.save
			    flash[:notice] = "File being uploaded"
			    redirect_to(:controller => 'retailer', :action => 'index')
				# else
					# flash[:notice] = "one excel file already uploaded"
					# redirect_to(:controller => 'retailer', :action => 'index')
				# end
			else
				puts "invalid file"
				flash[:notice] = "Select a valid excel file !!"
				redirect_to(:action => 'index')
		    end
			   
		rescue Exception => e
			puts "Exception : #{e}"
			flash[:notice] = "Please select an excel file !!!"
			redirect_to(:action => 'index')
		end
	end

	def new
		
	end

end

class UploadExcelToDb < Struct.new(:path, :file)

  	def perform
  		 v = File.open(path, "wb") { |f| f.write(file.read) }
		puts "uploading... : #{v} || path : #{path} || directory : #{directory}"
	    row_number = -1
		@user_count = 0
		new_retailers_list = []
		puts "path : #{Rails.public_path}/uploads/ck_retailers.xlsx"
		workbook = RubyXL::Parser.parse("#{Rails.public_path}/uploads/ck_retailers.xlsx")

		worksheet = workbook[0]

		# parsing the rows of excel sheet
		worksheet.each { |row|
		  
		  	if row_number >= 0

		  		r_code = row.cells[0] && row.cells[0].value
		  		if r_code.blank? 
		  			break
		  		end
		  		r_name = row.cells[1] && row.cells[1].value
		  		dse = row.cells[2] && row.cells[2].value
		  		r_route_no = row.cells[3] && row.cells[3].value

		  		puts "Details :  dse : #{dse} | rcode = #{r_code} | r_name = #{r_name} | r_route_no = #{r_route_no.to_i}"

				new_retailers_list.push(r_code)
		  		retailer = Retailer.where(:retailer_code => r_code).first

		  		# retailer not found
		  		if retailer.blank?
		  			retailer = Retailer.new
		  		end
			   
			    retailer.retailer_code = r_code
			    retailer.retailer_name = r_name
			    retailer.dse_code = dse
			    retailer.route_no = r_route_no.to_i.to_s
			    retailer.is_active = true

			    usr = User.where(:dse_code => dse).first
			    puts usr.inspect
			    if !usr
			    	puts "DSE code not allocated to any user : #{dse}"
			    	u = User.new
			    	u.dse_code = dse
			    	u.email = dse
			    	u.password = encrypt(dse)
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
		}
		deactivateOldEntries(new_retailers_list)
		Upload.last.is_completed = true
		Upload.last.save
		puts Upload.last
		puts "#{row_number } rows inserted"
  	end


	def deactivateOldEntries(new_retailers_list)
		retailer = Retailer.where('retailer_code NOT IN (?)', new_retailers_list)
				puts "All old retailers list"+retailer.inspect

		retailer.update_all( {:is_active => false})
	end
end
