require 'aws-sdk-s3'


# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.napoleonnews.com"

SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['BUCKETEER_BUCKET_NAME'],
  aws_access_key_id: ENV['BUCKETEER_AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'],
  aws_region: ENV['BUCKETEER_AWS_REGION'],
  acl: "public-read" # Allow public access
)

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add '/', changefreq: 'weekly'

  Category.find_each do |category|
    add category_path(category), lastmod: category.updated_at
  end

  Article.find_each do |article|
    add article_path(article), lastmod: article.updated_at
  end
end
