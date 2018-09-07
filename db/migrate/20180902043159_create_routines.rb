class CreateRoutines < ActiveRecord::Migration[5.1]
  def change
    create_table :routines do |t|
      t.integer :user_id
      t.integer :stage_id
      t.integer :exercise_id
      t.integer :set
      t.integer :rep
      t.integer :seconds_down
      t.integer :seconds_hold
      t.integer :seconds_up
      t.integer :porcentage

      t.timestamps
    end
  end
end
