module Reports
  extend ActiveSupport::Concern

### this is working well right now!! 8.25.15 and feeds almost_final

    included do
        require 'peddler'
        require 'csv'
    end
  
    module ClassMethods
    
        def report_details(token, marketplace_id, merchant)

          status = MWS::Sellers::Client.new(
            marketplace_id:        marketplace_id,
            merchant_id:           merchant.merchant_identifier, #this is Gennifers A2EUUGYN7CN0KC this is mine A340I3BHJ03NV9
            aws_access_key_id:     ENV["aws_access_key_id"],
            aws_secret_access_key: ENV["aws_secret_access_key"],
            auth_token:            token
          )
          
          
          status.get_service_status.inspect
          
          @client = MWS::Reports::Client.new(
            marketplace_id:        marketplace_id,
            merchant_id:           merchant.merchant_identifier, #this is Gennifers A2EUUGYN7CN0KC this is mine A340I3BHJ03NV9
            aws_access_key_id:     ENV["aws_access_key_id"],
            aws_secret_access_key: ENV["aws_secret_access_key"],
            auth_token:            token
          )
          

          @status_array = []

          #first we need to see if a FBA report has been requested in the past 1800 seconds
            begin
            @lookie_here = @client.get_report_list().parse
              rescue Excon::Errors::Unauthorized => e
                puts "We got the following API error #{e.message}"
                sleep 2 and retry
              rescue Excon::Errors::ServiceUnavailable => e
                puts "We got the following API error #{e.message}"
                sleep 2 and retry
              rescue Excon::Errors::Forbidden => e
                puts "We got the following API error #{e.message}"
                sleep 2 and retry
              rescue Excon::Errors::SocketError => e
                puts "We got the following socket error #{e.message}"
                sleep 2 and retry
              else
                puts "The report list was requested fine"
            end
            
        startup
        
        end
    
        def startup
          
          requested = @lookie_here["ReportInfo"].select { |x| x["ReportType"] == "_GET_AFN_INVENTORY_DATA_"  }
          
            if requested[0] != nil
              @fba_report_id = requested[0]["ReportId"]
              request_time = requested[0]["AvailableDate"]
              @difference = Time.now - Time.parse(request_time) #if the difference is > 1800 then request again, otherwise don't
                
                if @difference > 1800
                    request_active_report
                    request_fba_report
                else
                    @status_array << "_DONE_"
                    request_active_report
                end
            
            else
                
              @difference = 1900
              request_active_report
              request_fba_report
            
            end
        
        end
      
  #we gotta request the reports first..both active and fba
        def request_active_report
            begin
            #both of these return some info include the report request id..
            @active_report = @client.request_report("_GET_MERCHANT_LISTINGS_DATA_").parse

            rescue Excon::Errors::ServiceUnavailable
                puts "the active report had an issue"
                sleep 2 and retry
        
            else
                puts "The active report was requested fine"
            end
        
          if @difference < 1800
            find_report_status_just_active
          end
        
        end
  
        def request_fba_report
          begin
          #both of these return some info include the report request id..

            @fba_report = @client.request_report("_GET_AFN_INVENTORY_DATA_").parse
    
          rescue Excon::Errors::ServiceUnavailable
            
            puts "the FBA report had an issue"
            sleep 2 and retry
    
          else
      
            puts "The FBA report was requested fine"
            find_report_status_both
      
          end
  
        end
  
        def find_report_status_just_active
          begin
  
            @just_active_report_request_id = @active_report["ReportRequestInfo"]["ReportRequestId"]
      
      
            #get report list to find our requested report this fucking works!!!! sending along report request id so we just get our reports.
            @active_report_list = @client.get_report_request_list(report_request_id_list: @just_active_report_request_id).parse
      
            @report_status_active = @active_report_list["ReportRequestInfo"]["ReportProcessingStatus"]


          rescue Excon::Errors::ServiceUnavailable => e
            puts "The active report list had an issue"
            puts e
            puts e.class
            puts e.backtrace
            sleep 2 and retry
    
          else
            puts "The active report list was pulled ok"
          end
    
          #this worked.. f me..I think its an hash within an array within a hash..
          if @report_status_active == "_DONE_"
            @active_report_id = @active_report_list["ReportRequestInfo"]["GeneratedReportId"]
            @status_array << @report_status_active
            pull_reports
          else
            sleep 40
          find_report_status_just_active
          
          end
        end
  
  
        def find_report_status_both
          begin
            @status_array = []
      
            @active_report_request_id = @active_report["ReportRequestInfo"]["ReportRequestId"]
      
            @fba_report_request_id = @fba_report["ReportRequestInfo"]["ReportRequestId"]
      
            @id_request = [@active_report_request_id, @fba_report_request_id]
      
            #get report list to find our requested report this fucking works!!!! sending along report request id so we just get our reports.
            @report_list = @client.get_report_request_list(report_request_id_list: @id_request).parse
            #the above generates a hash.. hmm
      
            #this worked.. f me..I think its an hash within an array within a hash..
            @report_status_a = @report_list["ReportRequestInfo"][0]["ReportProcessingStatus"]
            @report_status_b = @report_list["ReportRequestInfo"][1]["ReportProcessingStatus"]
            
            @status_array << [@report_status_a, @report_status_b]
      
            puts @status_array.inspect
      
              if @report_status_a == "_DONE_" && @report_status_b == "_DONE_"
                @report_id_a = @report_list["ReportRequestInfo"][0]["GeneratedReportId"]
                @report_id_b = @report_list["ReportRequestInfo"][1]["GeneratedReportId"]
                pull_reports
              else
                sleep 40
                find_report_status_both
              end
      
          rescue Excon::Errors::ServiceUnavailable => e
            puts "The report list had an issue"
            puts e
            puts e.class
            puts e.backtrace
            sleep 2 and retry
          
          else
            puts "The report list was pulled ok"
          end
    
        end

        #this takes the data from find_report_status and if the reports are ready, pulls the reports and puts them in a CSV.
        def pull_reports
            
          puts "This is the FBA report ID #{@fba_report_id}"
          puts "This is the active report ID #{@active_report_id}"
      
            if @difference < 1800
              @report_id_b = @fba_report_id
              @report_id_a = @active_report_id
              
            else
              @report_id_a = @report_id_a
              @report_id_b = @report_id_b
            end
      
          begin
      
            @almost_fba_report = @client.get_report(@report_id_b).parse.to_csv
      
          rescue Excon::Errors::ServiceUnavailable => e
            puts "We had an issue with getting the data in the active and or fba report"
            puts e
            puts e.class
            puts e.backtrace
            sleep 1 and retry
        
          else
            puts "We got the data in the fba report"
          
          end
      
          got_inventory_array = CSV.new(@almost_fba_report, headers: true, :header_converters => :symbol).to_a.map {|row| row.to_hash }
 
          got_inventory_array.delete_if { |s| s[:quantity_available] == "0" || s[:quantity_available] == nil }

          got_inventory_array.each do |x|
            x.delete_if { |key, value| key == :fulfillmentchannelsku || key == :conditiontype || key == :warehouseconditioncode }
          end 
  ######### this returns my products with inventory > 0 and ASIN and MSKU and quantity avail.
          begin
          
          @almost_active_report = @client.get_report(@report_id_a).parse.to_csv
          
          rescue Excon::Errors::ServiceUnavailable => e
            puts "We had an issue with getting the data in the active and or fba report"
            puts e
            puts e.class
            puts e.backtrace
            sleep 1 and retry
    
          else
            puts "We got the data in the active report"
          
          end
        
          final_active_array = CSV.new(@almost_active_report, headers: true, :header_converters => :symbol).to_a.map {|row| row.to_hash }
          final_active_array.each do |wassup|
            wassup.delete_if { |key, value| key != :price && key != :asin1 }
          end
    ######### this returns the price and ASIN for all my inventory       
          h = final_active_array.each_with_object({}) { |value ,hash| hash[value[:asin1]] = value[:price] } 
  
  #this takes the active array which is an array of hashes, creates a new hash, and then in that hash sets the keys as the asins, and the values
  # for the keys as the prices in the array. 
  
          @final_report_array = got_inventory_array.each { |g| g[:price] = h[g[:asin]] if h.key?(g[:asin]) }
          binding.pry
          puts "got it, final_report_array!"
### the final array has the msku, asin and price in it.. 
  
        end
    end
end

