class Task < ActiveRecord::Base

  attr_accessible :name, :note, :due_date, :completed, :completed_date
  
  validates :name, presence: true
  
  has_and_belongs_to_many :user
end
