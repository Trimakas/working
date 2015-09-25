class RemoveColumnfromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :five_of_asin, :text
  end
end
