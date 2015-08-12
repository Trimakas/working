class CreateFixedMerchantTable < ActiveRecord::Migration
  def change
    create_table :merchants, id: false do |t|
      t.string :merchant_identifier, null: false
      t.string :name
      t.string :token
      t.string :marketplace
      t.string :password_digest
      t.string :email
    end
    add_index :merchants, :merchant_identifier, unique: true
  end
end
