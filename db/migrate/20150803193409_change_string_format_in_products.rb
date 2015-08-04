class ChangeStringFormatInProducts < ActiveRecord::Migration
  
  def up
    change_column :products, :title, :text
    change_column :products, :sellersku, :text
    change_column :products, :asin, :text    
    change_column :products, :price, :text    
  end

  def down
    change_column :products, :title, :string
    change_column :products, :sellersku, :string
    change_column :products, :asin, :string    
    change_column :products, :price, :string   
  end

end
