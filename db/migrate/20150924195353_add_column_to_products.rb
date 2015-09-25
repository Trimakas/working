class AddColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_variant, :boolean
    add_column :products, :variants, :text
  end
end
