class CreateUserInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_informations do |t|
      t.integer :user_id
      t.integer :user_type_id
      t.text :first_name
      t.text :last_name
      t.date :birth_date
      t.integer :genre
      t.string :height
      t.string :weight
      t.integer :sport
      t.integer :position
      t.string :next_competition
      t.integer :experience
      t.text :history_injuries
      t.date :pay_day
      t.integer :pay_program
      t.text :goal_1
      t.text :goal_2

      t.timestamps
    end
  end
end
