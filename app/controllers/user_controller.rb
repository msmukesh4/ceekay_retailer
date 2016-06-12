class UserController < ApplicationController

	layout "login_layout",only: [:login]
	# before_action :confirm_logged_in, :except	=> [:login, :validate_user, :index, :logout]

	def login
   		@user = User.new
      	# flash[:notice] = ""
	end

	# function to validate user
   	def validate_user
   		begin
   			@user = User.new(user_sign_in_params)
	      	# @user = User.find(params[:id])
	        puts "user : #{@user.inspect}"
	        if !@user.email.blank?
	    
		        u = User.where(:email => @user.email).first
		        puts "user_extracted : #{u.inspect}"

		        if u.blank?
		        	puts "user is blank"
		            flash[:notice] = "user with email #{@user.email} doesnot exist"
		            render('login')
		        else
		        	puts "user is not blank"
		            d_pass = decrypt(u.password)
		            puts "#{d_pass}"
		            if d_pass == @user.password
		            	puts "password matched"
		               	if u.is_first_logged_in
		               		puts "user is logged in : #{u.is_admin}"
		                  	if u.is_admin
		                  		puts "user is admin"
		                     	@user = User.find(u.id)
		                    	authorized_user = @user
		                	else
		                		puts "user is not admin"
		                    	flash[:notice] = "User cannot log in !! only admin can"
		                	end
		            	else
		            		puts "user is not logged in #{u.id}"
		            		flash[:notice] = "You are Successfully Logged in please Enter New Email id and password to continue..."
		            		redirect_to(:action => 'edit', :id => u.id)
		           			# redirection for change your password 
		           			# if user changes the password then make is_first_logged_in = true
		        		end
		    		else
		          		flash[:notice] = "Incorrect password"
		          		flash[:notice] = "please input password !!" if @user.password.blank?
		        	end
		     	end
		      	if authorized_user and u.is_first_logged_in
		      		puts "auth user"
		      		# TODO: mark user as logged in
		      		session[:user_id] = authorized_user.id
		      		session[:email] = authorized_user.email
			      	flash[:notice] = "You are now logged in."
			      	redirect_to(:controller => 'retailer', :action => 'index')
		      	# elsif !u.is_first_logged_in and authorized_user
		      	# 	session[:user_id] = authorized_user.id
		      	# 	session[:email] = authorized_user.email
			      # 	flash[:notice] = "You are now logged in."
		      	# 	render('edit')
		      	else
		      		puts "No auth user"
		      		render('login')
		      	end
		      	# redirect_to(:controller => 'retailer', :action => 'index')
		    else
		    	flash[:notice] = "please input email id !!"
		    	render('login')
		    end
   		rescue Exception => e
   			puts "Exception : #{e}"
   			# redirect_to(:action => 'login')
   		end
   	end

   	def edit
   		@user = User.find(params[:id])
		puts @user.inspect
   	end

   	def update

   		puts "in update method"
	   	# Find an existing object using form parameters
	    @user = User.find(params[:id])
	    if !@user.is_first_logged_in

		    # Update the object
		    if !check_params and @user.is_admin
			    if @user.update_attributes(user_update)

			    	u = User.find(params[:id])
			    	e_pass = encrypt(u.password)
			    	u.password = e_pass
			    	u.is_first_logged_in = true
			    	u.save
			      # If update succeeds, redirect to the index action
			      flash[:notice] = "user #{@user.id} updated successfully."
			      redirect_to(:controller => 'retailer', :action => 'index')
			    else
			      # If update fails, redisplay the form so user can fix problems
			      flash[:notice] = "invalid fields"
			      render('edit')
			    end
			else
				flash[:notice] = "Email ID and password cannot be blank and user should be admin"
		   		render('edit',:id => params[:id])
			end
		else
			redirect_to(:controller => retailer)
		end
   	end

   	def logout
   		# TODO: mark user as logged out
   		session[:user_id] = nil
      	session[:email] = nil
      	
	   flash[:notice] = "Logged out"
	   redirect_to(:action => "login")
   	end

   	private
	   	def user_sign_in_params
	        params.require(:user).permit(:id, :is_admin, :is_first_logged_in, :dse_code, :password, :email, :name, :dob, :contact_number)
	    end

	    def user_update
	        params.require(:user).permit(:id, :is_first_logged_in, :password, :email)
	    end
	    def check_params
	    	empty = false
	    	params[:user].values.each do |m|
	    		if m == "" or m == nil
	    			empty = true
	    		end
	    	end
	    	
	    	empty
	    end

end

