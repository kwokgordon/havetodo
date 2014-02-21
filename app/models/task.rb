class Task < ActiveRecord::Base

  # Set Task Scope
#  def self.default_scope
#    @user = User.find(current_user.id)
#    @user.tasks
#  end
  
  scope :no_duedate_tasks, -> { where("due_date IS NULL") }
  scope :with_duedate_tasks, -> { where.not("due_date IS NULL") }
  
  scope :completed_tasks, -> { where(completed: true) }
  scope :incomplete_tasks, -> { where(completed: false) }

  scope :overdue_tasks, -> { incomplete_tasks.with_duedate_tasks.where("due_date <= ?", Time.now.midnight) }
  scope :today_tasks, -> { incomplete_tasks.with_duedate_tasks.where(due_date: (Time.now.midnight)..(Time.now.midnight + 1.day)) }
  scope :tomorrow_tasks, -> { incomplete_tasks.with_duedate_tasks.where(due_date: (Time.now.midnight + 1.day)..(Time.now.midnight + 2.day)) }
  scope :this_week_tasks, -> { incomplete_tasks.with_duedate_tasks.where(due_date: (Time.now.midnight + 2.day)..(Time.now.midnight + 7.day)) }
  scope :future_tasks, -> { incomplete_tasks.with_duedate_tasks.where("due_date >= ?", (Time.now.midnight + 7.day)) }

  attr_accessible :name, :note, :due_date, :completed, :completed_date
  
  validates :name, presence: true
  
  has_and_belongs_to_many :user

end
