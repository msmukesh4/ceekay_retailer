class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :gen_uuid, :encrypt, :decrypt

  # this will ecript the data based on the key and Algorithm type
  def encrypt(data)
    
    cipher = OpenSSL::Cipher.new(ENV['ALGORITHM'])
    cipher.encrypt()
    cipher.key = ENV['KEY']
    crypt = cipher.update(data) + cipher.final()
    encrypted_data = (Base64.encode64(crypt))
    
    encrypted_data
  end

    # this will ecript the data based on the key and Algorithm type
  def decrypt(data)

    cipher = OpenSSL::Cipher.new(ENV['ALGORITHM'])
    cipher.decrypt()
    cipher.key = ENV['KEY']
    tempkey = Base64.decode64(data)
    decrypted_data = cipher.update(tempkey)
    decrypted_data << cipher.final()
      	
    decrypted_data
  end

  private

    def confirm_logged_in
      # puts session.inspect
      unless session[:user_id]
        flash[:notice] = "Please login !!"
        redirect_to(:controller => 'user', :action => 'login')
        return false
      else
        return true
      end
    end

end
