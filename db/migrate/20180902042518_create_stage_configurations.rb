class CreateStageConfigurations < ActiveRecord::Migration[5.1]
  def change
    create_table :stage_configurations do |t|
      t.integer :stage_id
      t.string :type
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
