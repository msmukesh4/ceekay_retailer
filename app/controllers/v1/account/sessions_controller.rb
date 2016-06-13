require 'json'
class V1::Account::SessionsController < V1::BaseController

	skip_before_action :verify_authenticity_token, only: [:demo, :login, :update_password]

	def demo
		respond_to do |format|
			puts "hello!!"
			format.json {render :json => { status: "yes u are connected"} }
		end
	end

	def login
		puts "#{params[:dse_code]},#{params[:password]}"	
		dse_code = params[:dse_code]
		password = params[:password]
		if !dse_code.blank? and !password.blank?
			result = auth(dse_code,password) 
			if result
				respond_to do |format|
					format.json {render :json => { success: "true", role: "#{@role}", access_token: "#{@token}", first_time_login: "#{@first_login}", dse_code: "#{@dse_code}" } }
				end
			else
				respond_to do |format|
					format.json {render :json => { success: "false", reason: "#{@reason}"} }
				end
			end
		else
			respond_to do |format|
				format.json {render :json => { success: "false", reason: "provide both dse_code and password"} }
			end
		end
	end

end