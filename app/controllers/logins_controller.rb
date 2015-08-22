class LoginsController < ApplicationController
    
    def new

    end
    
    
    def create
        merchant = Merchant.find_by(email: params[:email]) #so this just sets merchant to the user who is trying to login.
        
        if merchant && merchant.authenticate(params[:password])
            session[:merchant_id] = merchant.id
            log_in(merchant)
            flash[:success] = "You were logged in successfully"
            redirect_to merchant_path(merchant.id) #might want to update this to probably the merchant#show action..
        else
            flash.now[:danger] = "Snap! either your email or password is incorrect. Try again"
            render 'new'
        end
        
    end
    
    
    def destroy
        session[:merchant_id] = nil
        flash[:success] = "You have logged out"
        redirect_to root_path
    end
    
    
end
