class FixColumNames < ActiveRecord::Migration
  def change
        rename_column :products, :type, :product_type
  end
end
