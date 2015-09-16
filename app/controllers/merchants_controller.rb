class MerchantsController < ApplicationController
    include Reports
    include Call
    
    before_action :install, if: :shop_needs_install?

    def index
      binding.pry
      shop = Shop.find_by(shopify_domain: params[:shop])
      session[:current_shop_id] = shop.id
        
      redirect_to new_merchant_path
    end
    
    def new
      @merchant = Merchant.new
    end

    def create
        binding.pry
        @merchant = Merchant.new(merchant_params)
        @merchant.shop = current_shop
        if @merchant.save
            flash[:success] = "Thanks for signing up with ByteStand"
            session[:merchant_id] = @merchant.id
            redirect_to merchant_path(@merchant.id)
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
        params[:id] = session[:merchant_id]
        if params[:id] != nil
            @merchant = Merchant.find(params[:id]) #this returns the merchant who is signed in..
            @products = @merchant.products # this is supposed to be the products the
        else
            render 'index'
        end
    end
    
    def pull_from_amazon
        
        me = Merchant.find(params[:merchant_id])
        marketplace = me.marketplace
        token = me.token
        Merchant.report_details(token, marketplace, params[:merchant_id])
        Merchant.get_api(token, marketplace, params[:merchant_id])
        respond_to do |format|
            format.js {render inline: "location.reload();" }
        end
        
    end
  
private

  def shop_needs_install?
    return false if ! params.has_key?(:shop)
    ! Shop.exists?(shopify_domain: params[:shop])
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
