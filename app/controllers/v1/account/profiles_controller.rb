require 'json'
class V1::Account::ProfilesController < V1::BaseController

	skip_before_action :verify_authenticity_token, only: [:update_password, :edit_profile]

	def edit_profile
		puts "#{params[:email]}, #{params[:access_token]}, #{params[:dse_code]}, #{params[:contact_number]} , #{params[:name]}"
		if !params[:access_token].blank? and !params[:dse_code].blank?
			u = User.where(:dse_code => params[:dse_code]).first
			if u.blank?
				respond_to do |format|
					format.json {render :json => { success: "false", reason: "no user with the provided dse code"} }
				end
			else
				u.email = params[:email] if !params[:email].blank?
				u.contact_number = params[:contact_number] if !params[:contact_number].blank?
				u.name = params[:name] if !params[:name].blank?
				if u.save
					respond_to do |format|
						format.json {render :json => { success: "true", message: "User profile successfully updated"} }
					end
				else
					respond_to do |format|
						format.json {render :json => { success: "false", message: "unable to save user details"} }
					end
				end
			end
		
		else
			respond_to do |format|
				format.json {render :json => { success: "false", reason: "dse_code and access_token cannot be blank"} }
			end
		end
	end

	def update_password
		puts "#{params[:dse_code]}, #{params[:old_password]}, #{params[:new_password]}, #{params[:access_token]}"
		if !params[:dse_code].blank? and !params[:old_password].blank? and !params[:access_token].blank? and !params[:new_password].blank?
			if auth(params[:dse_code],params[:old_password],params[:access_token])
				u = User.where(:dse_code => params[:dse_code]).first
				u.password = encrypt(params[:new_password])
				u.is_first_logged_in = true if !u.is_first_logged_in
				if u.save
					respond_to do |format|
						format.json {render :json => { success: "true", message: "password successfully changed"} }
					end
				else
					respond_to do |format|
						format.json {render :json => { success: "false", reason: "unable to save new password"} }
					end
				end
			else
				respond_to do |format|
					format.json {render :json => { success: "false", reason: "#{@reason}"} }
				end
			end
		else
			respond_to do |format|
				format.json {render :json => { success: "false", reason: "provide all dse_code,new_password, old_password,access_token"} }
			end
		end

	end

end