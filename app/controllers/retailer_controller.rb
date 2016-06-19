class RetailerController < ApplicationController

	before_action :confirm_logged_in

	layout "print_layout",only: [:index, :mapdemo]

	def index
		puts "session user id : #{session[:user_id]}"
		@retailers = Retailer.where(:is_active => true)
	end

	def new
    	@retailer = Retailer.new
  	end

  	def create
	    # Instantiate a new object using form parameters
	    @retailer = Retailer.new(retailer_params)
	    if !@retailer.dse_code.blank? and !@retailer.retailer_code.blank?
	    	
		    user = User.where(:dse_code => @retailer.dse_code)
		    if user.blank?
		    	user = User.new
		    	user.dse_code = @retailer.dse_code
		    	e_pass = encrypt(@retailer.dse_code)
		    	user.password = e_pass
		    	user.access_token = SecureRandom.hex(10)
		    end
		    # Save the object
		    if @retailer.save
		    	user.save
			    # If save succeeds, redirect to the index action
			    flash[:notice] = "Retailer created successfully."
			    redirect_to(:action => 'index')
		    else
		      	# If save fails, redisplay the form so user can fix problems
		      	render('new')
		    end
		else
			flash[:notice] = "Retailer code and DSE code cannot be blank"
			render('new')
		end
	end

	def edit
		@retailer = Retailer.find(params[:id])
		puts @retailer.inspect
	end

	def update
	   	# Find an existing object using form parameters
	    @retailer = Retailer.find(params[:id])
	    puts "before update: "+@retailer.inspect
	    
	    # Update the object
	    if @retailer.update_attributes(retailer_params)
	    	if !@retailer.dse_code.blank?
		    	user = User.where(:dse_code => @retailer.dse_code).first
		    	# if cannot find dse in user table create a new user with the new dse value
		    	if user.blank?
		    		user = User.new
			    	user.dse_code = @retailer.dse_code
			    	e_pass = encrypt(@retailer.dse_code)
			    	user.password = e_pass
			    	user.access_token = SecureRandom.hex(10)
			    	user.save
		    	end
	    	end
	    	puts "after update "+@retailer.inspect
	      	# If update succeeds, redirect to the index action
	      	flash[:notice] = "retailer #{@retailer.id} updated successfully."
	      	redirect_to(:action => 'index')
	    else
	      # If update fails, redisplay the form so user can fix problems
	      flash[:notice] = "Invalid fields"
	      render('edit')
	    end
	end

	def delete
	    @retailer = Retailer.find(params[:id])
	end

	def destroy
	    retailer = Retailer.find(params[:id])
	    retailer.is_active = false
	    retailer.save
	    flash[:notice] = "retailer '#{retailer.retailer_name}' destroyed successfully."
	    redirect_to(:action => 'index')
	end

	def mapdemo

		@retailers = Retailer.all
		puts "#{@retailers.inspect}"
		
	end

	def retailer_params
      # same as using "params[:retailer]", except that it:
      # - raises an error if :retailer is not present
      # - allows listed attributes to be mass-assigned
      params.require(:retailer).permit(:retailer_code, :retailer_name, :dse_code, :route_no, :contact_number, :tin, :pan)
    end
end