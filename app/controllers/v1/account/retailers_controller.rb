require 'json'
class V1::Account::RetailersController < V1::BaseController

	skip_before_action :verify_authenticity_token, only: [:get_retailer_code_list, :get_retailer_details]


	def get_retailer_code_list
		puts "#{params[:dse_code]}, #{params[:access_token]}, #{params[:route]}"
		if !params[:dse_code].blank? and !params[:access_token].blank? and !params[:route].blank?

			retailers = Retailer.where(:dse_code => params[:dse_code], :route_no => params[:route])
			if !retailers.blank?
				retailer_code_list = retailers.map(&:retailer_code).join(',')
				respond_to do |format|
					format.json {render :json => { success: "true", reason: retailer_code_list} }
				end
			else
				respond_to do |format|
					format.json {render :json => { success: "false", reason: "no retailers found with the provided dse code and route"} }
				end
			end
		end
			respond_to do |format|
				format.json {render :json => { success: "false", reason: "provide all dse_code and access_token and route"} }
			end
		end
	end

end