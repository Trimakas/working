class ChangeDataTypeForEncryptedToken < ActiveRecord::Migration
  def change
    change_column :merchants, :encrypted_token, :binary
  end
end
