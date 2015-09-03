class ChangeMerchantFieldToText < ActiveRecord::Migration
  def up
    change_column :merchants, :encrypted_token, :text
  end

  def down
    change_column :merchants, :encrypted_token, :string
  end
end
