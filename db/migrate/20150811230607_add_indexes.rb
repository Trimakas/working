class AddIndexes < ActiveRecord::Migration
  def change
    add_index :products, :merchant_identifier
  end
end
