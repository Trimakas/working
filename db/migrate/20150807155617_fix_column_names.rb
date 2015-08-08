class FixColumnNames < ActiveRecord::Migration
  def change
    rename_column :merchants, :merchant_id, :merchant_identifier
    rename_column :products, :merchant_id, :merchant_identifier
  end
end
