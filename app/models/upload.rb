class Upload < ActiveRecord::Base
	
	def export_xls_to_db(path)
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
		puts "#{row_number } rows inserted"
		return row_number
	end

	def deactivateOldEntries(new_retailers_list)
		retailer = Retailer.where('retailer_code NOT IN (?)', new_retailers_list)
				puts "All old retailers list"+retailer.inspect

		retailer.update_all( {:is_active => false})
	end

end
