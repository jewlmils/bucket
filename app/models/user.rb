class User < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :tasks

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :uniqueness => {:allow_blank => true}
end
