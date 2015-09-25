class AddSplitInfoToProducts < ActiveRecord::Migration
  def change
    add_column :products, :five_of_asin, :text
    add_column :products, :twenty_of_title, :text
  end
end
