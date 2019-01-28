class UserRoutine < ApplicationRecord
    belongs_to :user
    has_many :routine_exercise, dependent: :destroy
end
