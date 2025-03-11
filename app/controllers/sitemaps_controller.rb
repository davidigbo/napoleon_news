class SitemapsController < ApplicationController
  require 'aws-sdk-s3'

  def show
    s3 = Aws::S3::Client.new(
      access_key_id: ENV['BUCKETEER_AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'],
      region: ENV['BUCKETEER_AWS_REGION']
    )

    bucket_name = ENV['BUCKETEER_BUCKET_name']
    file_key = 'sitemap.xml.gz'

    begin
      obj = s3.get_object(bucket: bucket_name, key: file_key)
      send_data obj.body.read, type: 'application/gzip', disposition: 'inline'
    rescue Aws::S3::Errors::NoSuchKey
      render plain: "Sitemap not found", status: :not_found
    end
  end
end