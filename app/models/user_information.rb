class UserInformation < ApplicationRecord
    belongs_to :user
    has_one :user_type
    mount_uploader :img_url, ImageUploader
end
