require 'rubyXL'
class UploadController < ApplicationController

	# before_action :confirm_logged_in

	def export_xls_to_db(path)
		row_number = -1
		@user_count = 0
		workbook = RubyXL::Parser.parse("/home/mukesh/Desktop/ck_retailers.xlsx")
		worksheet = workbook[0]
		worksheet.each { |row|
		  	
		  	if row_number >= 0
		  		dse = row.cells[2] && row.cells[2].value
		  		retailer = Retailer.new
			    retailer.retailer_code = row.cells[0] && row.cells[0].value
			    retailer.retailer_name = row.cells[1] && row.cells[1].value
			    retailer.dse_code = dse
			    retailer.route_no = row.cells[3] && row.cells[3].value

			    usr = User.where(:dse_code => dse).first
			    puts usr.inspect
			    if !usr
			    	puts "dse code not allocated to any user : #{dse}"
			    	u = User.new
			    	u.dse_code = dse
			    	u.email = dse
			    	u.password = encrypt(dse)
			    	if u.save
			    		@user_count += 1
			    	else
			    		puts "user with dse code #{dse} not saved"
			    	end
			    else
			    	puts "dse code allocated to user #{usr.id}"
			    end
			    retailer.save
			    puts retailer.inspect
		  	end
		  	row_number += 1
		  	puts row_number
		}
		
		puts "#{row_number } rows inserted"
		return row_number
	end

	def index
		if !Upload.last.blank?
			flash[:notice] = "one excel file already uploaded"
			redirect_to(:controller => 'retailer', :action => 'index')
		end
	end

	def create
		begin
			name = params[:upload][:file].original_filename
			ext = name.split(".").last
		    puts "name : #{name}, ext : #{ext}"
		    if ext == "xlsx" or ext == "xls"
		    	directory = "public/uploads"
			    path = File.join(directory, name)
			    v = File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
			    puts "uploading... : #{v} || path : #{path}"
			    if Upload.last.blank?
				    rows = export_xls_to_db(path)
				    upload = Upload.new
				    upload.file_name = name
				    upload.path = directory
				    upload.save
				    flash[:notice] = "File uploaded and #{rows} retailes and #{@user_count} users created"
				    redirect_to(:controller => 'retailer', :action => 'index')
				else
					flash[:notice] = "one excel file already uploaded"
					redirect_to(:controller => 'retailer', :action => 'index')
				end
			else
				puts "invalid file"
				flash[:notice] = "Select a valid excel file !!"
				redirect_to(:action => 'index')
		    end
			   
		rescue Exception => e
			puts "Exception : #{e}"
			flash[:notice] = "please select an excel file !!!"
			redirect_to(:action => 'index')
		end
	end

	def new
		
	end


end
