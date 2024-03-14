class Category < ApplicationRecord
  belongs_to :user
  has_many :tasks

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :description, presence: true

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