class Task < ActiveRecord::Base

  # Set Task Scope
#  def self.default_scope
#    @user = User.find(current_user.id)
#    @user.tasks
#  end
  
  scope :completed_tasks, -> { where(completed: true) }
  scope :incomplete_tasks, -> { where(completed: false) }
  
  scope :no_duedate_tasks, -> { incomplete_tasks.where("due_date IS NULL") }
  scope :with_duedate_tasks, -> { incomplete_tasks.where.not("due_date IS NULL") }
  
  scope :overdue_tasks, -> { with_duedate_tasks.where("due_date < ?", Time.now.midnight) }
  scope :today_tasks, -> { with_duedate_tasks.where("due_date >= ? and due_date < ?", (Time.now.midnight), (Time.now.midnight + 1.day)) }
  scope :tomorrow_tasks, -> { with_duedate_tasks.where("due_date >= ? and due_date < ?", (Time.now.midnight + 1.day), (Time.now.midnight + 2.day)) }
  scope :this_week_tasks, -> { with_duedate_tasks.where("due_date >= ? and due_date < ?", (Time.now.midnight + 2.day),(Time.now.midnight + 7.day)) }
  scope :future_tasks, -> { with_duedate_tasks.where("due_date >= ?", (Time.now.midnight + 7.day)) }

  attr_accessible :name, :note, :priority, :due_date, :due_time, :completed, :completed_date, :completed_user_id, :completed_user_name
  
  validates :name, presence: true
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :tasklists
  
  has_many :task_comments, :dependent => :destroy

end
