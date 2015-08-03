class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :merchant_id
      t.string :token
      t.string :marketplace

      t.timestamps null: false
    end
  end
end
