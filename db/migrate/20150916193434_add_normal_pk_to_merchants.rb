class AddNormalPkToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :id, :primary_key
  end
end