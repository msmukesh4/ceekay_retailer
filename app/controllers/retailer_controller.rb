class RetailerController < ApplicationController

	before_action :confirm_logged_in

	layout "print_layout",only: [:index, :map]
	# layout "demo", only:[:test]

	def index
		puts "session user id : #{session[:user_id]}"
		@offset = params[:offset].blank? ? 0 : params[:offset]
		@dse_code_search_param = params[:dse_code]
		@route_search_param = params[:route]
		@retailer_search_param = params[:retailer_name]
		@branch_search_param = params[:branch]
		@latitude_search_param = params[:latitude]
		@longitude_search_param = params[:longitude]
		@address_search_param = params[:address]
		lastUpload = Upload.last
		@isUploadUnderProgress = !lastUpload.is_completed
		if @isUploadUnderProgress
			flash[:notice] = "An Upload is still under progress in the background, records added till now: #{lastUpload.records_added}+"
		end

	    @retailers = Retailer.where("dse_code LIKE ? AND route_no LIKE ? AND retailer_name LIKE ? AND branch_code LIKE ? AND CAST(latitude AS text) LIKE ? AND CAST(longitude AS text) LIKE ? AND address LIKE ?" ,"%#{@dse_code_search_param}%","%#{@route_search_param}%","%#{@retailer_search_param}%","%#{@branch_search_param}%","%#{@latitude_search_param}%","%#{@longitude_search_param}%","%#{@address_search_param}%").limit(Retailer::PER_PAGE).offset(@offset.to_i*Retailer::PER_PAGE)
		puts "reatilers:  : #{@retailers.map(&:id).inspect}"

		respond_to do |format|
			format.js
			format.html
		end
	end

	def new
    	@retailer = Retailer.new
  	end

  	def create
  		r_code = params[:retailer][:retailer_code]
  		branch_code = params[:branch_code]
  		rtlr = Retailer.where(:retailer_code => r_code, :branch_code => branch_code).first
  		if rtlr.blank?
		    # Instantiate a new object using form parameters
		    user_found = false
		    @retailer = Retailer.new(retailer_params)
		    if !@retailer.dse_code.blank? and !@retailer.retailer_code.blank?
		    	
			    user = User.where(:dse_code => @retailer.dse_code)
			    if user.blank?
			    	user = User.new
			    	user.dse_code = @retailer.dse_code
			    	e_pass = encrypt(@retailer.dse_code)
			    	user.password = e_pass
			    	user.access_token = SecureRandom.hex(10)
			    	user_found = false
			    else
			    	user_found = true
			    end
			    # Save the object
			    if @retailer.save
			    	user.save if !user_found

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
		else
			flash[:notice] = "Retailer already created"
			redirect_to(:action => 'index', :retailer_code => r_code)
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
	      	flash[:notice] = "Retailer #{@retailer.id} updated successfully."
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
	    flash[:notice] = "Retailer '#{retailer.retailer_name}' destroyed successfully."
	    redirect_to(:action => 'index')

	end

	def map
		@dse_code_search_param = params[:dse_code]
		@route_search_param = params[:route]
		@retailer_search_param = params[:retailer_name]
		@branch_search_param = params[:branch]
		@latitude_search_param = params[:latitude]
		@longitude_search_param = params[:longitude]
		@address_search_param = params[:address]
		lastUpload = Upload.last
		@isUploadUnderProgress = !lastUpload.is_completed
		if @isUploadUnderProgress
			flash[:notice] = "An Upload is still under progress in the background!!"
		end

		if @latitude_search_param.blank? and @longitude_search_param.blank?
	    	@retailers = Retailer.where("dse_code LIKE ? AND route_no LIKE ? AND retailer_name LIKE ? AND branch_code LIKE ? AND CAST(latitude AS text) NOT LIKE ? AND CAST(longitude AS text) NOT LIKE ? AND address LIKE ?" ,"%#{@dse_code_search_param}%","%#{@route_search_param}%","%#{@retailer_search_param}%","%#{@branch_search_param}%","%#{0.0}%","%#{0.0}%","%#{@address_search_param}%")
		else
			@retailers = Retailer.where("dse_code LIKE ? AND route_no LIKE ? AND retailer_name LIKE ? AND branch_code LIKE ? AND CAST(latitude AS text) LIKE ? AND CAST(longitude AS text) LIKE ? AND address LIKE ?" ,"%#{@dse_code_search_param}%","%#{@route_search_param}%","%#{@retailer_search_param}%","%#{@branch_search_param}%","%#{@latitude_search_param}%","%#{@longitude_search_param}%","%#{@address_search_param}%")
		end
	end

	def test
		
	end

	def retailer_params
      # same as using "params[:retailer]", except that it:
      # - raises an error if :retailer is not present
      # - allows listed attributes to be mass-assigned
      params.require(:retailer).permit(:retailer_code, :retailer_name, :dse_code, :branch_code, :route_no, :contact_number, :pan,:tin, :is_active)

    end
end