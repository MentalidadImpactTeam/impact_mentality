class CreateExercises < ActiveRecord::Migration[5.1]
  def change
    create_table :exercises do |t|
      t.integer :category_id
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
