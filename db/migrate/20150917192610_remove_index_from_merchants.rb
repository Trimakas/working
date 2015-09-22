class RemoveIndexFromMerchants < ActiveRecord::Migration
  def change
    remove_index :merchants, :merchant_identifier
  end
end
