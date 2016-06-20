class UserController < ApplicationController

	layout "login_layout"
	before_action :confirm_logged_in, :except	=> [:login, :validate_user, :index, :logout]

	def login
   		@user = User.new
      	# flash[:notice] = ""
	end

	# function to validate user
   	def validate_user
   		begin
   			authorized_user = nil
   			@user = User.new(user_sign_in_params)
	        puts "user : #{@user.inspect}"
	        if !@user.email.blank?
	    
		        u = User.where(:email => @user.email).first
		        puts "user_extracted : #{u.inspect}"

		        if u.blank?
		        	puts "user is blank"
		            flash[:notice] = "user with email #{@user.email} doesnot exist"
		            # render('login')
		        else
		        	puts "user is not blank"
		            d_pass = decrypt(u.password)
		            puts "password : #{d_pass}"
		            if d_pass == @user.password
		            	puts "password matched"
		                if u.is_admin
		                	puts "user is admin : #{u.is_admin}"
		        			if u.is_first_logged_in
			                  	puts "user has already logged in !!"
			                   	puts u.inspect
			                    authorized_user = u.id

		                	else
		                		# redirection for change your password 
		           				# if user changes the password then make is_first_logged_in = true
		           				authorized_user = u.id

		                		puts "user is not logged in #{u.id}"
		            			flash[:notice] = "You are Successfully Logged in please Enter New Email id and password to continue..."
		            			# redirect_to(:action => 'edit', :id => u.id)
		               		end
		           		else
		            		puts "user is not admin"
		                   	flash[:notice] = "User cannot log in !! only admin can"
		                   	# render('login')
		        		end
		    		else
		          		flash[:notice] = "Incorrect password"
		          		flash[:notice] = "please input password !!" if @user.password.blank?
		        	end
		     	end

		     	if authorized_user
		     		puts "auth user"
		     		usr = User.find(authorized_user)
		     		# TODO: mark user as logged in
		     		puts "#{usr.id} || #{usr.inspect}"
		      		session[:user_id] = usr.id
		      		session[:email] = usr.email
			      	redirect_to(:action => 'edit', :id => authorized_user)
			      	# render()
		     	else
		     		puts "No auth user"
		     		render('login')
		     	end
		    else
		    	flash[:notice] = "please input email id !!"
		    	render('login')
		    end
   		rescue Exception => e
   			puts "Exception : #{e}"
   			redirect_to(:action => 'login')
   		end
   	end

   	def edit
   		@user = User.find(params[:id])
   		if @user.is_first_logged_in
   			flash[:notice] = "you have already changed your password !!"
   			redirect_to(:controller => 'retailer', :action => 'index')
   		end
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
	        params.require(:user).permit(:id, :is_admin, :is_first_logged_in, :dse_code, :password, :email, :name, :dob, :contact_number, :is_active)
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

