Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new(ENV['CEEKAY_AMAZON_SECRET_KEY'], ENV['CEEKAY_AMAZON_ACCESS_KEY']),
})

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['CEEKAY_S3_BUCKET'])