class Category < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :tasks

  # Validations
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :description, presence: true

  # Method to update the status of the category based on its associated tasks.
  def update_status
    if self.tasks.empty?
      self.status = "Empty"
    elsif self.tasks.any? { |task| task.status == "Pending" || task.status == "Priority" }
      self.status = "Pending"
    else
      self.status = "Completed"
    end
    self.save
  end
  
end