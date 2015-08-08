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
            redirect_to products_path ## I actually think this should be the show action below.. 
            #so it'll show the products of the merchant that is logged in.. I hope??
        else
            render 'edit'
        end
    end
    
    def show
       @merchant = Merchant.find(params[:id]) #this returns the merchant who is signed in..
       binding.pry
       @products = Product.where(@merchant.merchant_identifier == products.merchant_identifier).paginate(page: params[:page], per_page: 4) # this is supposed to be the products the
       #logged in merchant owns..
       
       #in the show page we can just loop through @products because its already associated with the right
       #merchant!!!
    end
    
        private
        def merchant_params
           params.require(:merchant).permit(:name, :email, :password, :merchant_identifier, :token, :marketplace) 
        end
    
end
