class SessionsController < ApplicationController
  include ShopifyApp::SessionsController
  
  def new

  end
  
  def create
        scopes = 'read_products, write_products'
        redirect_uri = "https://this-should-work-trimakas.c9.io"
        shopify_domain = "#{params[:shop]}.myshopify.com"
        state = DateTime.now.to_i*1000
        redirect_to "https://#{shopify_domain}/admin/oauth/authorize?client_id=#{ENV["shopify_api"]}&scope=#{scopes}&redirect_uri=#{redirect_uri}&state=#{state}"
  end
  
  def callback
      
  end
  
  def destroy
  
  end
  
end
