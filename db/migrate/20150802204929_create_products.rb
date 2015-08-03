class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :sellersku
      t.string :asin
      t.string :price
      t.string :merchant_id

      t.timestamps null: false
    end
  end
end
