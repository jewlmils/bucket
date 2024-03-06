class Task < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  
  def self.get_by_status(status)
    self.all.select do |task|
        task.status == status
    end
  end
end
