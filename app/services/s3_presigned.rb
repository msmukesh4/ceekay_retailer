require 'aws-sdk-resources'
require 'net/http'

class S3Manager
  def self.presign(filename, limit)

    creds = Aws::Credentials.new(ENV['CEEKAY_AMAZON_ACCESS_KEY'], ENV['CEEKAY_AMAZON_SECRET_KEY'])
    s3 = Aws::S3::Resource.new(region: 'us-west-1', credentials: creds)
    obj = s3.bucket('ceekaybucket').object(filename)
    params = { acl: 'public-read' }
    params[:content_length] = limit if limit
    url=obj.presigned_url(:put, params)
  end

  def self.fetchFileFromS3(filename)

 	creds = Aws::Credentials.new(ENV['CEEKAY_AMAZON_ACCESS_KEY'], ENV['CEEKAY_AMAZON_SECRET_KEY'])
    s3 = Aws::S3::Client.new(region: 'us-west-1', credentials: creds)   
    directory = "#{Rails.public_path}"
    path = File.join(directory, "/ceekay.xlsx")
    File.open(path, 'wb') do |file|
  		reap = s3.get_object({ bucket:'ceekaybucket', key: filename }, target: file)
	end
  end

end
