class Task < ApplicationRecord
  belongs_to :category

  # Validations to ensure presence of name and description fields
  validates :name, presence: true
  validates :description, presence: true
end