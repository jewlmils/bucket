class Task < ApplicationRecord
  belongs_to :category

  validates :name, presence: true
  validates :description, presence: true
end