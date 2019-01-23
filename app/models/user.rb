class User < ApplicationRecord
  has_one :user_information, dependent: :destroy
  has_one :user_type
  has_many :user_conekta_token
  has_many :user_conekta_subscription

  accepts_nested_attributes_for :user_information
  accepts_nested_attributes_for :user_conekta_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  attr_accessor :first_name, :last_name, :trainer_code

end
