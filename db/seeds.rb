# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Product.delete_all
Merchant.delete_all

Product.create([{:title=> "Title 1", :sellersku=>"2273500028", :asin=>"B0076E32F8", :price=>"15.49", :merchant_identifier=>"A2EUUGYN7CN0Kg"}, 
  {:title=> "Title 2",:sellersku=>"5154464774", :asin=>"B00013J6HY", :price=>"445.94", :merchant_identifier=>"A2EUUGYN7CN0Kg"}, 
  {:title=> "Title 3",:sellersku=>"5164589013", :asin=>"B007CB4OFM", :price=>"51.62", :merchant_identifier=>"A2EUUGYN7CN0Kg"}, 
  {:title=> "Title 4",:sellersku=>"5167477065", :asin=>"B0044WWCB0", :price=>"139.95", :merchant_identifier=>"A2EUUGYN7CN0KC"}, 
  {:title=> "Title 5",:sellersku=>"5168073402", :asin=>"B009T3H9IK", :price=>"18.49", :merchant_identifier=>"A2EUUGYN7CN0KC"}, 
  {:title=> "Title 6",:sellersku=>"5161195001", :asin=>"B00Q6X06W2", :price=>"11.49", :merchant_identifier=>"A2EUUGYN7CN0KC"}])
  
Merchant.create([{:name=>"Gennifer", :merchant_identifier=>"A2EUUGYN7CN0KC", :token=>"amzn.mws.88a6be2d-bd98-3abd-f596-0bb2a1ed1adf", :marketplace=> "ATVPDKIKX0DER"},
  {:name=>"Todd", :merchant_identifier=>"A2EUUGYN7CN0KX", :token=>"none", :marketplace=> "ATVPDKIKX0DER"}])