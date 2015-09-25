class Product < ActiveRecord::Base
    belongs_to :merchant
    
    validates :sellersku, uniqueness: true
    validates :asin, uniqueness: true
    
    include Send
    include Call
    
    before_save     :split_off
    
    
    def split_off
        @merchant = self.merchant_id
        counter = 0
        self.twenty_of_title = self.title[0,20]
        counter += 1
        if counter == @length
            set_variations
        end
    end
    
    def self.set_variations
        binding.pry
        Product.where(merchant_id: @merchant).find_each do |merch|
            variations = merch.group(:twenty_of_title).count
        end
        
    end
    
end