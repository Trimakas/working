class MerchantsController < ApplicationController

    def new
        @merchant = Merchant.new
    end

    def create
        @merchant = Merchant.new(merchant_params)
        
        if @merchant.save
            flash[:success] = "Thanks for signing up with ByteStand"
            session[@merchant_id] = @merchant.id
            redirect_to products_path
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
            redirect_to products_path ## need to change this to just show the merchant page.. 
        else
            render 'edit'
        end
    end
    
        private
        def merchant_params
           params.require(:merchant).permit(:name, :email, :password, :merchant_id, :token, :marketplace) 
        end
    
end
