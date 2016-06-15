class RetailerController < ApplicationController

	before_action :confirm_logged_in

	def index
		puts "session user id : #{session[:user_id]}"
		@retailers = Retailer.all
	end

	def new
    	@retailer = Retailer.new
  	end

  	def create
	    # Instantiate a new object using form parameters
	    @retailer = Retailer.new(retailer_params)
	    user = User.new

	    # Save the object
	    if @retailer.save
	    	user.dse_code = @retailer.dse_code
	    	e_pass = encrypt(@retailer.dse_code)
	    	user.password = e_pass
	    	user.access_token = SecureRandom.hex(10)
	    	user.save
		    # If save succeeds, redirect to the index action
		    flash[:notice] = "Retailer created successfully."
		    redirect_to(:action => 'index')
	    else
	      	# If save fails, redisplay the form so user can fix problems
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
	    puts @retailer.inspect
	    user = User.where(:dse_code => @retailer.dse_code).first
	    puts "user from unupdated retailer : "+user.inspect
	    # Update the object
	    if @retailer.update_attributes(retailer_params)
	    	user.dse_code = @retailer.dse_code
	    	user.save
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
	    retailer = Retailer.find(params[:id]).destroy
	    flash[:notice] = "retailer '#{retailer.retailer_name}' destroyed successfully."
	    redirect_to(:action => 'index')
	end

	def locations_on_map

		@retailers = Retailer.all
		
	end

	def retailer_params
      # same as using "params[:retailer]", except that it:
      # - raises an error if :retailer is not present
      # - allows listed attributes to be mass-assigned
      params.require(:retailer).permit(:retailer_code, :retailer_name, :dse_code, :route_no)
    end
end