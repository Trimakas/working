module Send
  extend ActiveSupport::Concern

    # included do
    #     require 'peddler'
    #     require 'csv'
    # end
  
    module ClassMethods
    
        def push_it(sellersku, shop, token)
          
          
          session = ShopifyAPI::Session.new(shop,token)
          self.store(session)
          if session.valid?
            ShopifyAPI::Base.activate_session(session)
            sellersku.each do |xyz|
              yours = find_by sellersku: xyz
              new_product = ShopifyAPI::Product.new
              binding.pry
              new_product.title = yours.title
              new_product.id = yours.sellersku
              new_product.product_type = yours.product_type
              new_product.vendor = yours.vendor
              new_product.body_html = yours.description
              new_product.images = yours.image
              new_product.save
              binding.pry

            end
          else
            redirect_to merchant_path(params)
        
          end
    
        end
    
    end

end
