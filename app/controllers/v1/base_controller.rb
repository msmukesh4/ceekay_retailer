class V1::BaseController < ApplicationController
#   before_filter :set_current_user

# private

#   def set_current_user
#     if doorkeeper_token
#       @current_user ||= User.find(doorkeeper_token.resource_owner_id)
#     end
#     current_user = @current_user
#     current_user
#   end
  
   def auth(dse_code,password,access_token = nil)
		u = User.where(:dse_code => dse_code).first
		puts "inspected user in auth :"+u.inspect
		if u.blank?
			@reason = "user with this dse_code does not exist !!"
		else
			if decrypt(u.password) == password  # user auth success
				if u.is_admin # user is admin
					@role = "admin"
				else
					@role = "appuser"
				end
				if access_token
					if access_token != u.access_token
						@reason = "invalid token"
						return false
					end
				else
					@token = u.access_token
				end
				@first_login = !u.is_first_logged_in
				return true
			else
				@reason	= "incorrect password !!"
			end
		end
		return false
	end

end