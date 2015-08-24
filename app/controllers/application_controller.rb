class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  helper_method :current_merchant, :logged_in?
  include SessionsHelper
  
  def current_merchant
    @current_merchant ||= Merchant.find(session[:merchant_id]) if session[:merchant_id]
    binding.pry
  end
  
  def logged_in?
    !!current_merchant
  end
  
end
