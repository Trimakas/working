require "openssl"

module ShopifyTokenManager
  extend self
    def exchange_token(params)
      temp_token = params[:code]
      result = HTTParty.post("https://#{params[:shop]}/admin/oauth/access_token",
                       :query => {:client_id => ENV["shopify_api"], :client_secret => ENV["shopify_secret"], 
                       :code => temp_token})
      result["access_token"]
    end    

end
