class CreateSubcategories < ActiveRecord::Migration[5.1]
  def change
    create_table :subcategories do |t|
      t.integer :category_id
      t.string :name

      t.timestamps
    end
  end
end
