class ChangeDataTypeForMerchants < ActiveRecord::Migration
  def change
    rename_column :merchants, :token, :encrypted_token
  end
end
