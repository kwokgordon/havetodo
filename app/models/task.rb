class Task < ActiveRecord::Base

  # Set Task Scope
  def self.default_scope
    get_user
    @user.tasks
  end
  
  scope :overdue_tasks, -> { where.not("due_date IS NULL").where("due_date <= ?", Time.now.midnight) }
  scope :today_tasks, -> { where.not("due_date IS NULL").where(due_date: (Time.now.midnight)..(Time.now.midnight + 1.day)) }
  scope :tomorrow_tasks, -> { where.not("due_date IS NULL").where(due_date: (Time.now.midnight + 1.day)..(Time.now.midnight + 2.day)) }
  scope :this_week_tasks, -> { where.not("due_date IS NULL").where(due_date: (Time.now.midnight + 2.day)..(Time.now.midnight + 7.day)) }
  scope :future_tasks, -> { where.not("due_date IS NULL").where("due_date >= ?", (Time.now.midnight + 7.day)) }
  scope :no_duedate_tasks, -> { where("due_date IS NULL") }

  attr_accessible :name, :note, :due_date, :completed, :completed_date
  
  validates :name, presence: true
  
  has_and_belongs_to_many :user

  def get_user
    @user = User.find(current_user.id)
  end  
end
