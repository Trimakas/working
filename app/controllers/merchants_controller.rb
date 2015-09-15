class MerchantsController < ApplicationController
    include Reports
    include Call

    def index
        shop = Shop.find_by(shopify_domain: params[:shop])
        merch = Merchant.find_by(domain: params[:shop])
    
        if shop.shopify_token == "123"
            shop.update(shopify_token: params[:code])
        else
            redirect_to merchant_path(merch.merchant_identifier)
        end
    end
    
    def new
        @merchant = Merchant.new
    end

    def create
        @merchant = Merchant.new
        @merchant.name = merchant_params[:name]
        @merchant.email = merchant_params[:email]
        @merchant.password = merchant_params[:password]        
        @merchant.merchant_identifier = merchant_params[:merchant_identifier]
        @merchant.marketplace = merchant_params[:marketplace]
        @merchant.token = merchant_params[:token]
        @merchant.domain = Rails.cache.read("domain")
        
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
        def merchant_params
           params.require(:merchant).permit(:id, :name, :email, :password, :merchant_identifier, :token, :marketplace, :domain) 
        end
    
end
