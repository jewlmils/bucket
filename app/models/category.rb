class Category < ApplicationRecord
  belongs_to :user  
  has_many :tasks  

  # Method to retrieve categories by status.
  def self.get_by_status(status)
    self.all.select do |category|
      category.status == status
    end
  end

  # Method to update the status of a category based on its tasks.
  def update_status
    if self.tasks == []  # If category has no tasks,
      self.status = "Empty"  # set status to "Empty".
    elsif self.tasks.any? { |task| task.status == "Pending" || [] }  # If any task is pending,
      self.status = "Pending"  # set status to "Pending".
    else  # Otherwise,
      self.status = "Completed"  # set status to "Completed".
    end
    self.save  # Save the changes.
  end

  # Method to retrieve tasks of a category by status.
  def tasks_by_status(status)
    self.tasks.select do |task|
      task.status == status
    end
  end
end
