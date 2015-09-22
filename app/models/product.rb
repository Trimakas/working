class Product < ActiveRecord::Base
    belongs_to :merchant
    
    validates :sellersku, uniqueness: true
    
    include Send
end