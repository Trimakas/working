class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
 
  include SessionsHelper
  
  def current_merchant
    @current_merchant ||= Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end
  helper_method :current_merchant, :logged_in?
  
  def current_shop
    @current_shop ||= Shop.find(session[:current_shop_id]) if session[:current_shop_id]
  end
  helper_method :current_shop, :logged_in?
  
  def logged_in?
    !!current_merchant
  end
  
  def self.store(session)
    shop = Shop.find_or_initialize_by(shopify_domain: session.url)
    shop.shopify_token = session.token
    shop.save!
    shop.id
  end

  def self.retrieve(id)
    return unless id
    shop = Shop.find(id)
    ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
  rescue ActiveRecord::RecordNotFound
    nil
  end

end
