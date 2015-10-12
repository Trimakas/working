class MerchantsController < ApplicationController
    include Reports
    include Call
    
    before_action :install, if: :shop_needs_install?

    def new
      @merchant = Merchant.new
    end

    def create
        @merchant = Merchant.new(merchant_params)
        @merchant.domain = current_shop.shopify_domain
        if @merchant.save
          flash[:success] = "Thanks for signing up with ByteStand"
          session[:merchant_id] = @merchant.id
          redirect_to @merchant
        else
           render 'new'
        end
        
    end

    def edit
        @merchant = Merchant.find(params[:id])
    end

    def update
        @merchant = Merchant.find(params[:id])
        if @merchant.update(merchant_params)
            flash[:success] = "Your profile has been updated"
            redirect_to merchant_path
        else
            render 'edit'
        end
    end
    
    def show
      @merchant ||= Merchant.find(session[:merchant_id])
      domain = @merchant.domain
      # token = Shop.find_by(shopify_domain: domain).shopify_token
      # sesh = ShopifyAPI::Session.new(domain, token)
      # SessionStorage.store(sesh)
      # binding.pry
      # SessionStorage.retrieve(@merchant.domain)
      # binding.pry
    end
    
    def pull_from_amazon
        current_merchant = Merchant.find(params[:merchant_id])
        marketplace = current_merchant.marketplace
        token = current_merchant.token
        Merchant.report_details(token, marketplace, current_merchant)
        Merchant.get_api(token, marketplace, current_merchant)
        Product.set_variations(current_merchant)
        Product.delete_duplicate_asins(current_merchant)
        redirect_to :back
        
        
    end
  
private

  def shop_needs_install?
    return false if !params.has_key?(:shop)
    !Shop.exists?(shopify_domain: params[:shop])
  end
  
  def install
    token = ShopifyTokenManager.exchange_token(params)
    Shop.create!(shopify_token: token, shopify_domain: params[:shop])
  end
  

        def merchant_params
           params.require(:merchant).permit(:id, :name, :email, :password, :merchant_identifier, 
                                            :token, :marketplace) 
        end
        
  def current_shop
      @current_shop ||= Shop.find(session[:current_shop_id])
  end
    
end
