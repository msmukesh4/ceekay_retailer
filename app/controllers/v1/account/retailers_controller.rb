require 'json'
class V1::Account::RetailersController < V1::BaseController

	skip_before_action :verify_authenticity_token, only: [:get_retailer_code_list, :get_retailer_details, :update_retailer_address,:get_my_retailers,:get_my_retailers_updated_today]

	# GET v1/account/retailer/get_retailer_code_list
	def get_retailer_code_list
		puts "#{params[:dse_code]}, #{params[:access_token]}, #{params[:route]}"
		if !params[:dse_code].blank? and !params[:access_token].blank? and !params[:route].blank?
				
			usr = User.where(:dse_code => params[:dse_code]).first
			if !usr.blank?
				token = usr.access_token
				if token == params[:access_token]
					retailers = Retailer.where(:dse_code => params[:dse_code], :route_no => params[:route])
					if !retailers.blank?
						retailer_code_list = retailers.map(&:retailer_code).join(',')
						respond_to do |format|
							format.json {render :json => { success: "true", retailer_code_list: retailer_code_list} }
						end
					else
						respond_to do |format|
							format.json {render :json => { success: "false", reason: "no retailers found with the provided dse code and route"} }
						end
					end
				else
					respond_to do |format|
						format.json {render :json => { success: "false", reason: "invalid access token"} }
					end
				end
			else
				respond_to do |format|
						format.json {render :json => { success: "false", reason: "user with provided dse code doesnot exist"} }
				end
			end
		else
			respond_to do |format|
				format.json {render :json => { success: "false", reason: "provide all dse_code and access_token and route"} }
			end
		end
	end

	# GET v1/account/retailer/get_retailer_details
	def get_retailer_details
		puts "#{params[:dse_code]}, #{params[:access_token]}, #{params[:route]} , #{params[:retailer_code]}"
		if !params[:dse_code].blank? and !params[:access_token].blank? and !params[:route].blank? and !params[:retailer_code].blank?
				
			usr = User.where(:dse_code => params[:dse_code]).first
			if !usr.blank?
				token = usr.access_token
				if token == params[:access_token]
					retailer = Retailer.where(:dse_code => params[:dse_code], :route_no => params[:route], :retailer_code => params[:retailer_code] ).first
					if !retailer.blank?
						respond_to do |format|
							format.json {render :json => { success: "true", retailer_code: retailer.retailer_code, :retailer_name => retailer.retailer_name, :dse_code => retailer.dse_code, :route => retailer.route_no, :address => retailer.address, :latitude => retailer.latitude, :longitude => retailer.longitude} }
						end
					else
						respond_to do |format|
							format.json {render :json => { success: "false", reason: "no retailers found with the provided dse code,route and retailer_code"} }
						end
					end
				else
					respond_to do |format|
						format.json {render :json => { success: "false", reason: "invalid access token"} }
					end
				end
			else
				respond_to do |format|
						format.json {render :json => { success: "false", reason: "user with provided dse code doesnot exist"} }
				end
			end
		else
			respond_to do |format|
				format.json {render :json => { success: "false", reason: "provide all dse_code and access_token and route and retailer_code"} }
			end
		end
	end

	# POST v1/account/retailer/update_retailer_address
	def update_retailer_address
		puts "#{params[:dse_code]}, #{params[:access_token]}, #{params[:retailer_code]}, #{params[:latitude]}, #{params[:longitude]}, #{params[:address]}"
		if !params[:dse_code].blank? and !params[:access_token].blank? and !params[:retailer_code].blank?

			usr = User.where(:dse_code => params[:dse_code]).first
			if !usr.blank?
				token = usr.access_token
				if token == params[:access_token]
					retailer = Retailer.where(:dse_code => params[:dse_code], :retailer_code => params[:retailer_code]).first

					if !retailer.blank?
						retailer.address = params[:address] if !params[:address].blank?
						retailer.latitude = params[:latitude] if !params[:latitude].blank?
						retailer.longitude = params[:longitude] if !params[:longitude].blank?
						if retailer.save
							respond_to do |format|
								format.json {render :json => { success: "true", reason: "retailer updated successfully" } }
							end
						else
							respond_to do |format|
								format.json {render :json => { success: "false", reason: "failed to save retailer" } }
							end
						end
					else
						respond_to do |format|
							format.json {render :json => { success: "false", reason: "no retailers found with the provided dse code and retailer_code"} }
						end
					end
				else
					respond_to do |format|
						format.json {render :json => { success: "false", reason: "invalid access token"} }
					end
				end
			else
				respond_to do |format|
						format.json {render :json => { success: "false", reason: "user with provided dse code doesnot exist"} }
				end
			end
		else
			respond_to do |format|
				format.json {render :json => { success: "false", reason: "provide all dse_code and access_token and retailer_code"} }
			end
		end
	end

	# GET v1/account/retailer/get_my_retailers
	def get_my_retailers
		retailer_array = []
		puts "#{params[:dse_code]}, #{params[:access_token]}"
		if !params[:dse_code].blank? and !params[:access_token].blank?
				
			usr = User.where(:dse_code => params[:dse_code]).first
			if !usr.blank?
				token = usr.access_token
				if token == params[:access_token]
					retailers = Retailer.where(:dse_code => params[:dse_code])
					if !retailers.blank?

						retailers.each do |rtlr|
							retailer_details = {
								:retailer_code => rtlr.retailer_code,
								:retailer_name => rtlr.retailer_name,
								:dse_code => rtlr.dse_code,
								:route => rtlr.route_no,
								:address => rtlr.address,
								:latitude => rtlr.latitude,
								:longitude => rtlr.longitude
							}
							retailer_array << retailer_details
						end
						json_retailer_details = JSON[retailer_array]

						respond_to do |format|
							format.json {render :json => { success: "true", retailers: JSON[json_retailer_details]} }
						end
					else
						respond_to do |format|
							format.json {render :json => { success: "false", reason: "no retailers found with the provided dse code"} }
						end
					end
				else
					respond_to do |format|
						format.json {render :json => { success: "false", reason: "invalid access token"} }
					end
				end
			else
				respond_to do |format|
						format.json {render :json => { success: "false", reason: "user with provided dse code doesnot exist"} }
				end
			end
		else
			respond_to do |format|
				format.json {render :json => { success: "false", reason: "provide both dse_code and access_token"} }
			end
		end
	end

	# GET v1/account/retailer/get_my_retailers_updated_today
	def get_my_retailers_updated_today
		retailer_array = []
		puts "#{params[:dse_code]}, #{params[:access_token]}"
		if !params[:dse_code].blank? and !params[:access_token].blank?
				
			usr = User.where(:dse_code => params[:dse_code]).first
			if !usr.blank?
				token = usr.access_token
				if token == params[:access_token]
					retailers = Retailer.where(:dse_code => params[:dse_code],updated_at: (Time.now - 24.hours)..Time.now )
					if !retailers.blank?
						retailers.each do |rtlr|
							retailer_details = {
								:retailer_code => rtlr.retailer_code,
								:retailer_name => rtlr.retailer_name,
								:dse_code => rtlr.dse_code,
								:route => rtlr.route_no,
								:address => rtlr.address,
								:latitude => rtlr.latitude,
								:longitude => rtlr.longitude
							}
							retailer_array << retailer_details
						end
						json_retailer_details = JSON[retailer_array]

						respond_to do |format|
							format.json {render :json => { success: "true", retailers: JSON[json_retailer_details]} }
						end
					else
						respond_to do |format|
							format.json {render :json => { success: "false", reason: "no retailers found with the provided dse code"} }
						end
					end
				else
					respond_to do |format|
						format.json {render :json => { success: "false", reason: "invalid access token"} }
					end
				end
			else
				respond_to do |format|
						format.json {render :json => { success: "false", reason: "user with provided dse code doesnot exist"} }
				end
			end
		else
			respond_to do |format|
				format.json {render :json => { success: "false", reason: "provide both dse_code and access_token"} }
			end
		end
	end

end