class Product < ActiveRecord::Base
    belongs_to :merchant, :foreign_key => 'merchant_identifier', :primary_key => 'merchant_identifier'
    
    validates :sellersku, uniqueness: true
end