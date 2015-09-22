class RmMarkidentFromProds < ActiveRecord::Migration
  def change
    remove_column :products, :merchant_identifier, :string
  end
end
