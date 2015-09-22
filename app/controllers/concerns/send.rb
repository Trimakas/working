module Send
  extend ActiveSupport::Concern

    # included do
    #     require 'peddler'
    #     require 'csv'
    # end
  
    module ClassMethods
    
        
    
        def push_it(sellersku, shop, token)
          store = Shop.find_by(shopify_domain: shop)
          push_session = SessionStorage.retrieve(store)
          if push_session.valid?
            ShopifyAPI::Base.activate_session(push_session)
            sellersku.each do |each_sku|
              yours = find_by sellersku: each_sku
              new_product = ShopifyAPI::Product.new
              new_product.title = yours.title
              
              all_my_variants = []
              my_variant1 = ShopifyAPI::Variant.new(
                        :price                => yours.price,
                        :inventory_management => 'shopify',
                        :fulfillment_service => 'amazon_marketplace_web',
                        :inventory_quantity   => 1,
                        :compare_at_price => yours.compare_at_price,
                        :sku => 123,
                        :option1 => "First"
                        #:weight => yours.weight - something is up with this.. way off..
                        #:weight_unit => #I gotta get this.. especially for the foreign folks..
                        )
              
              all_my_variants << my_variant1
              
              my_variant2 = ShopifyAPI::Variant.new(
                        :price                => yours.price,
                        :inventory_management => 'shopify',
                        :fulfillment_service => 'amazon_marketplace_web',
                        :inventory_quantity   => 3,
                        :compare_at_price => yours.compare_at_price,
                        :sku => 345,
                        :option1 => "Second"
                        #:weight => yours.weight - something is up with this.. way off..
                        #:weight_unit => #I gotta get this.. especially for the foreign folks..
                        )
              
              all_my_variants << my_variant2
              
              new_product.variants = all_my_variants
              new_product.product_type = yours.product_type
              new_product.vendor = yours.vendor
              new_product.body_html = yours.description
              image_array_for_shopify = []
              image_hash = {}
              image_hash["src"] = yours.image
              image_array_for_shopify << image_hash
              new_product.images = image_array_for_shopify
              new_product.inventory_quantity = 10
              new_product.save
            end
          else
            redirect_to merchant_path(store.merchant_id)
        
          end
    
        end
    
    end

end
