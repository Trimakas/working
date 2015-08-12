class MerchantsController < ApplicationController

    def index
    
    end
    
    def new
        @merchant = Merchant.new
    end

    def create
        @merchant = Merchant.new(merchant_params)
        
        if @merchant.save
            flash[:success] = "Thanks for signing up with ByteStand"
            session[:merchant_id] = @merchant.id
            redirect_to merchant_path
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
       @merchant = Merchant.find(params[:id]) #this returns the merchant who is signed in..
       binding.pry
       @products = @merchant.products.paginate(page: params[:page], per_page: 4) # this is supposed to be the products the
       #logged in merchant owns..
       binding.pry
    end
    
        private
        def merchant_params
           params.require(:merchant).permit(:id, :name, :email, :password, :merchant_identifier, :token, :marketplace) 
        end
    
end
