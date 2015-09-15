module Token
  extend ActiveSupport::Concern

    included do
        require "openssl"
    end
    
    module ClassMethods
    
        def get_token(params)
        
            temp_token = params[:code]
            temp_state = params[:state]
            temp_hmac = params[:hmac]
            temp_stamp = params[:timestamp]
            temp_shop = params[:shop]
            
            shop = Shop.find_by shopify_domain: temp_shop
            binding.pry
            #this is how to authenticate the hmac address..
            start = OpenSSL::Digest::SHA256.new
            secret = ENV['shopify_secret']
            message = "shop=#{temp_shop}&timestamp=#{temp_stamp}"
            
            finish = OpenSSL::HMAC.hexdigest(start, secret, message)
            
            if shop.valid?
                @get_perm_token = HTTParty.post("https://#{shop.shopify_domain}/admin/oauth/access_token",
                     :query => {:client_id => ENV["shopify_api"], :client_secret => ENV["shopify_secret"], 
                     :code => temp_token})
            end
            shop.shopify_token = @get_perm_token.parsed_response["access_token"]
            shop.save
            binding.pry
        end
    
    end

end
