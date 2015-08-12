class Product < ActiveRecord::Base
    belongs_to :merchant, :foreign_key => 'merchant_identifier', :primary_key => 'merchant_identifier'
    
    def self.search(search)
        if search    
            where('title like ? OR asin like ? OR sellersku like ?', "%#{search}%", "%#{search}%", "%#{search}%")
            #where('asin like ?', "%#{search}%")
            #where('sellersku like ?', "%#{search}%")
        else
            self.all
        end
    end
    
end