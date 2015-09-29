class Product < ActiveRecord::Base
    belongs_to :merchant
    
    validates :sellersku, uniqueness: true
    validates :asin, uniqueness: true
    serialize :variants
    
    include Send
    include Call
    
    before_save     :split_off
    
    
    def split_off
        @merchant = self.merchant_id
        self.twenty_of_title = self.title[0,20]
    end
    
    def self.set_variations(merchant)
        grouped_and_counted_products = Product.where(merchant_id: merchant).group(:twenty_of_title).count
        just_variations_hash = grouped_and_counted_products.select {|key, value| value > 1}
        just_variations_hash.each do |key, value|
           actual_variants = Product.where(twenty_of_title: "#{key}")
           array_of_asins = actual_variants.pluck(:asin)
                actual_variants.each do |update_variants|
                    update_variants.update(variants: array_of_asins, is_variant: true)
                end
        end

    end
    
    def self.delete_duplicate_asins(merchant)
        self.where(is_variant: true, merchant_id: merchant.id).find_each do |variant_list|
            variant_list.variants.delete(variant_list.asin)
            variant_list.save
            end
    end
    
    
end