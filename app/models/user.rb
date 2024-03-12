class User < ApplicationRecord
  # Associations
  has_many :categories, dependent: :destroy
  has_many :tasks

  # Devise authentication configuration
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end