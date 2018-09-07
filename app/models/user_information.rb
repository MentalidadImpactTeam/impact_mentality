class UserInformation < ApplicationRecord
    belongs_to :user
    has_one :user_type
end
