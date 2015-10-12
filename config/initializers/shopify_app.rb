ShopifyApp.configure do |config|
  config.api_key = ENV["shopify_api"]
  config.secret = ENV["shopify_secret"]
  config.scope = 'read_products, write_products'
  config.redirect_uri = 'https://this-should-work-trimakas.c9.io/'
  config.embedded_app = true
end
