class Task < ApplicationRecord
  belongs_to :category

  # Validations to ensure presence of name and description fields
  validates :name, presence: true
  validates :description, presence: true
  
  # Class method to filter tasks by status
  def self.get_by_status(status)
    self.all.select do |task|
        task.status == status
    end
  end
end