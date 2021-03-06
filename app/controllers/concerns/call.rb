### this is working well right now!! 8.25.15. should get data from almost_report and provide the final array of products

module Call
  extend ActiveSupport::Concern
  
  included do
    require 'nokogiri'
    require 'open-uri'
    require 'uri'
    require 'peddler' #peddler uses the AWS info from the MWS console ONLY..this doesn't change from what I can tell
    require 'vacuum' #vacuum uses the aws key from the AWS console
  end

module ClassMethods
    
    def get_api(token, marketplace_id, merchant)
        @asins = []
    
        #@final_report_array = [{:sellersku=>"2273500028", :asin=>"B0044WWCB0", :price=>"15.49"}]
        
        # @final_report_array = [{:sellersku=>"2273500028", :asin=>"B0015R9YL8", :price=>"15.49"}, 
        # {:sellersku=>"5154464774", :asin=>"B00J7QTLTE", :price=>"40.97"}, 
        # {:sellersku=>"5164589013", :asin=>"B007CB4OFM", :price=>"51.62"}, 
        # {:sellersku=>"5161195001", :asin=>"B00Q6X06W2", :price=>"11.49"}]
        @final_report_array.each { |x|  @asins << x[:asin] }
        @merchant_id = merchant.id
        @product_array = []
  
        @client_call = MWS::Products::Client.new(
        marketplace_id:        marketplace_id,
        merchant_id:           merchant.merchant_identifier,
        aws_access_key_id:     ENV["aws_access_key_id"],
        aws_secret_access_key: ENV["aws_secret_access_key"]
        )
      
        @client_call.auth_token = token
        puts @client_call.get_service_status
        @asins.each do |x|
      
            def call_api(x)  
                begin
                  @y = @client_call.get_matching_product(x).parse
                rescue Excon::Errors::Unauthorized => e
                  puts "We got the following API error #{e.message}"
                  sleep 2 and retry
                rescue Excon::Errors::ServiceUnavailable => e
                  puts "We got the following API error #{e.message}"
                  sleep 2 and retry
                rescue Excon::Errors::Forbidden => e
                  puts "We got the following API error #{e.message}"
                  sleep 2 and retry
                else
                  puts "Call to the product api was fine"
                end
            end
            
            call_api(x)

            if @y["status"] == "ClientError"
                puts @y["Error"]["Message"]
                bad = @asins.index(x)
                puts "This is bad.. #{bad}"
                good = bad + 1
                send_asin = @asins[good]
                call_api(send_asin)
                @asins.delete_if {|z| z == x }
                puts @asins.inspect
            end
         
            relationships = @y["Product"]["Relationships"]
            if relationships.nil?
                @is_parent = true
            else
                @is_parent = false
            end
        
            @into_api = @y["Product"]["AttributeSets"]["ItemAttributes"]
        
            vendor = @into_api.key?("Brand")
              if vendor
                vendor = @into_api["Brand"]
              else  
                vendor = "We didn't get a vendor"
              end
       
            material = @into_api.key?("MaterialType")
              if material
                material = @into_api["Brand"]
              else  
                material = nil
              end
            
            title = @into_api.key?("Title")
              if title
                title = @into_api["Title"]
              else  
                title = "We didn't get a title"
              end
       
            type = @into_api.key?("ProductGroup")
              if type
                type = @into_api["ProductGroup"]
              else  
                type = "We didn't get a product type"
              end

            @color = @into_api.key?("Color")
              if @color
                @color = @into_api["Color"]
              else  
                @color = nil
              end
        
            size = @into_api.key?("Size")
                if size
                size = @into_api["Size"]
            else
                size = nil
            end
        
            weight = @into_api.key?("PackageDimensions")
        
              if weight
                x_weight = @into_api["PackageDimensions"].key?("Weight")
                
                if x_weight
                  weight = @into_api["PackageDimensions"]["Weight"]["__content__"].to_f
                  weight_grams = (weight*453).to_i
                end
              else
                weight = nil
              end
          
            package_height = @into_api["PackageDimensions"].key?("Height")
              if package_height
                package_height = @into_api["PackageDimensions"]["Height"]["__content__"]
              else 
                package_height = nil
              end
        
            package_length = @into_api["PackageDimensions"].key?("Length")
              if package_length
                package_length = @into_api["PackageDimensions"]["Length"]["__content__"]
              else 
                package_length = nil
              end
        
            package_width = @into_api["PackageDimensions"].key?("Width")
              if package_width
                package_width = @into_api["PackageDimensions"]["Width"]["__content__"]
              else 
                package_width = nil
              end
  
            compare_at_price = @into_api.key?("ListPrice")
              if compare_at_price
                compare_at_price = @into_api["ListPrice"]["Amount"]   
              else 
                compare_at_price = nil
              end
          

            low_image = @into_api.key?("SmallImage")
              if low_image
                low_image = @into_api["SmallImage"]["URL"]
                hi_image = low_image.gsub(/SL75/, 'UL1500')
              else 
                hi_image = "We didn't get an image"
              end
          
            bullets = @into_api.key?("Feature")
              if bullets
                bullets = @into_api["Feature"]
              else
                bullets = "We did not get any bullets"
              end
          
              def get_description(x)
                puts "This is the x variable: #{x}"
                vac = Vacuum.new
                
                vac.configure(
                  aws_access_key_id:     ENV["aws_access_key_id2"],
                  aws_secret_access_key: ENV["aws_secret_access_key2"],
                  associate_tag:         "tag"
                )
                
                begin
                  uno = vac.item_lookup(
                      query: {'ItemId'=> x,
                              'ResponseGroup' => 'EditorialReview'
                      },
                       persistent: false
                      )
                rescue Excon::Errors::ServiceUnavailable
                  puts "the description lookup had an issue"
                  sleep 5 and retry
                end
                
                y = uno.to_h
                @description = y["ItemLookupResponse"]["Items"]["Item"].key?("EditorialReviews")
                  if @description
                    @description = y["ItemLookupResponse"]["Items"]["Item"]["EditorialReviews"]["EditorialReview"]["Content"]
                  else
                    @description = "We did not get a description"
                  end 
              end
              
              get_description(x)
              
              spot = @asins.index(x)
              
              results = {:asin => x, :bullets => bullets, :title => title, :package_height => package_height,
                        :package_length => package_length, :vendor => vendor, :type => type, :color => @color, 
                        :image => hi_image, :package_width => package_width, :material => material,
                        :size => size, :weight => weight, :compare_at_price => compare_at_price,
                        :description => @description, :price => @final_report_array[spot][:price], 
                        :sellersku => @final_report_array[spot][:sellersku], :merchant_id => @merchant_id,
                        :inventory => @final_report_array[spot][:quantity_available]
                        }
                        
              @product_array << results
              @length = @product_array.length
              @product_array.each do |save|
                product = Product.new
                product.title = save[:title]
                product.bullets = save[:bullets]
                product.package_height = save[:package_height]
                product.package_length = save[:package_length]
                product.package_width = save[:package_width]
                product.material = save[:material]
                product.vendor = save[:vendor]
                product.product_type = save[:type]
                product.color = save[:color]
                product.image = save[:image]
                product.size = save[:size]
                product.inventory = save[:inventory]
                product.weight = save[:weight]
                product.compare_at_price = save[:compare_at_price]
                product.description = save[:description]
                product.asin = save[:asin]
                product.price = save[:price]
                product.sellersku = save[:sellersku]
                product.merchant_id = save[:merchant_id]
                product.save
              end
    
      end
      
    end

end

end

