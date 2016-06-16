require 'json'
class V1::Account::DsesController < V1::BaseController

	skip_before_action :verify_authenticity_token, only: [:get_dse_routes]
	
	# GET v1/account/dse/get_dse_routes

	def get_dse_routes
		puts "#{params[:dse_code]}, #{params[:access_token]}"
		if !params[:dse_code].blank? and !params[:access_token].blank?
			usr = User.where(:dse_code => params[:dse_code]).first
			if !usr.blank?
				token = usr.access_token
				if token == params[:access_token]
					retailers = Retailer.where(:dse_code => params[:dse_code]).select(:route_no).uniq

					if !retailers.blank?
						routes = retailers.map(&:route_no).join(',')
						respond_to do |format|
							format.json {render :json => { success: "true", route: routes} }
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