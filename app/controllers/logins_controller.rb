class LoginsController < ApplicationController
    
    def new
        
    end
    
    
    def create
        merchant = Merchant.find_by(email: params[:email])
        if merchant && merchant.authenticate(params[:password])
            session[:merchant_id] = merchant.id
            flash[:success] = "You were logged in successfully"
            redirect_to root_path
        else
            flash.now[:danger] = "Either your email or password is incorrect"
            render 'new'
        end
        
    end
    
    
    def destroy
        session[:merchant_id] = nil
        flash[:success] = "You have logged out"
    end
    
    
end
