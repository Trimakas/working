module Send
  extend ActiveSupport::Concern
  
    module ClassMethods
    
      def make_session_active(sellersku, shop, token)
        
        store = Shop.find_by(shopify_domain: shop)
        push_session = SessionStorage.retrieve(store)
        if push_session.valid?
          ShopifyAPI::Base.activate_session(push_session)
        else
          redirect_to merchant_path(store.merchant_id)
        end
      end

#######this is where the process starts..      
      def does_this_sku_exist_on_shopify(sellersku, shop, token)
          
          make_session_active(sellersku, shop, token) #when user logs in token is retrieved and session is activated..
          sellersku.each do |each_sku|
            @find_this_product_in_db = find_by sellersku: each_sku              
            @find_on_shopify = ShopifyAPI::Product.where( title: @find_this_product_in_db.twenty_of_title)
            binding.pry
## The above variable can be an issue.. this is because you can't search by sku, only by the Shopify product id.
            if @find_on_shopify[0] == nil
                push_parent_product(sellersku, shop, token)
            else
                update_product_on_shopify(@find_on_shopify, @find_this_product_in_db)
            end
          end
      end

      #make_a_variant is for variants and regular products, because ALL products must have a variant to capture
      #the below fields.
      
      def push_a_variant(sellersku, product)
            
        @all_my_variants = []
        if product.variants == nil
          variant = sellersku
          make_variants(variant)
        else
          product.variants.each do |variants|
            make_variants(variants)
          end
        end
      end  
      
      def set_variant_options(variant)
        #@options can be 1 or 2 items long.. 
        how_many_options = @options.length
        
        if how_many_options == 1
          if @options.include?("Color") 
            @option1 = variant.color
          elsif @options.include?("Size")
            @option1 = variant.size
          else
            @option1 = variant.material
          end
        else
          @option1 = variant.color
          @option2 = variant.size
        end
        
      end
      
      def set_product_options(product)
      
      choices = {
        "Color" => product.color,
        "Size" => product.size
      }
      
      choices.delete_if {|key, value| value == nil}
      choices = choices.keys
        
        if product.color.nil? && product.size.nil?
          @options = "Material"
        end
        
        if choices.length == 1  
          @options = [{name: choices[0]}, {name: "Size"}]
        else
          @options = [{name: choices[0]}, {name: choices[1]}]
        end
      end
      
      
      def make_variants(variant)
          product_variant = find_by sellersku: variant
          my_variant = ShopifyAPI::Variant.new
            my_variant.price = product_variant.price
            my_variant.inventory_management = 'shopify'
            my_variant.fulfillment_service = 'amazon_marketplace_web'
            my_variant.inventory_quantity = product_variant.inventory
            #my_variant.compare_at_price = product_variant.compare_at_price
            my_variant.sku = product_variant.sellersku
            
            if product_variant.is_variant == true
              set_variant_options(product_variant)
              my_variant.option1 = @option1
              @option2 != nil ? my_variant.option2 = @option2 : nil
            end
            
            
            assign_images_to_product(product_variant)
            #:weight => yours.weight - something is up with this.. way off..
            #:weight_unit => #I gotta get this.. especially for the foreign folks..
                    
          @all_my_variants << my_variant
      end
      
      def assign_images_to_product(product)
        @image_array_for_shopify = []
        image_hash = {}
        image_hash["src"] = product.image
        @image_array_for_shopify << image_hash
      end
      
      def push_parent_product(sellersku, shop, token)
          
          sellersku.each do |each_sku|
            db_product = find_by sellersku: each_sku
            new_product = ShopifyAPI::Product.new
            new_product.title = db_product.title
            new_product.product_type = db_product.product_type
            #pretty sure this is how it works.. options in the parent product are the titles for the
            #drop downs.. so something like Size, Color, Material.. 
            #and then in the variation Option 1 would be the value for that title.. like if the parent product
            #option was "Size" then Option 1 for the variation would be "Medium"
            
            if db_product.is_variant == true
              set_product_options(db_product)
              new_product.options = @options
            end
            
            new_product.vendor = db_product.vendor
            new_product.body_html = db_product.description
            
            assign_images_to_product(db_product)
      
            new_product.images = @image_array_for_shopify
            new_product.inventory_quantity = db_product.inventory
            new_product.inventory_management = "shopify"
            new_product.fulfillment_service = "amazon_marketplace_web"
            
            push_a_variant(each_sku, db_product)
            
            new_product.variants = @all_my_variants

            new_product.save
          
              if db_product.is_variant == true
                assign_pics_to_variants(new_product)
              end
            
            end          
      end
  
      def update_product_on_shopify(shopify_product, db_product)
            shopify_product.each do |product_to_update|
              product_to_update.title = db_product.title
              product_to_update.product_type = db_product.product_type
              product_to_update.vendor = db_product.vendor
              product_to_update.body_html = db_product.description
              image_array_for_shopify = []
              image_hash = {}
              image_hash["src"] = db_product.image
              image_array_for_shopify << image_hash
              product_to_update.images = image_array_for_shopify
              product_to_update.inventory_quantity = db_product.inventory
              product_to_update.save
            end
        
      end
      
      ## This is going to be an issue when I have more than 1 image.. I'm going to have to know which image goes with which variant
      def assign_pics_to_variants(main_product)
        ids = []
        main_product.variants.each do |variant|
          id = variant.id

          ids << id #this is a list of the variant ids that then have to be assigned to an image..
        end
          main_product.images[0].variant_ids = ids
          main_product.save

          #the above just takes care of the first image.. in the future should loop through the images..

      end
      
  
  
    end
end

