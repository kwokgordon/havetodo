class TaskComment < ActiveRecord::Base

  attr_accessible :comment
  
  belongs_to :task

end
