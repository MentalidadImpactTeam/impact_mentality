class User < ApplicationRecord
  has_one :user_information, dependent: :destroy
  has_one :user_type

  accepts_nested_attributes_for :user_information, :user_type
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable
end
