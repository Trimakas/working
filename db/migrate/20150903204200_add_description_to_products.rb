class AddDescriptionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :description, :text
    add_column :products, :bullets, :text
    add_column :products, :package_height, :string
    add_column :products, :package_length, :string    
    add_column :products, :vendor, :string
    add_column :products, :type, :string
    add_column :products, :color, :string
    add_column :products, :image, :binary
    add_column :products, :package_width, :string
    add_column :products, :size, :string
    add_column :products, :weight, :string
    add_column :products, :compare_at_price, :string
  end
end
