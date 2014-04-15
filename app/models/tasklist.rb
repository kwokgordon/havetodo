class Tasklist < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :tasks
  
  attr_accessible :name

  validates :name, presence: true

  def to_param
    "#{id}-#{name}"
  end

end
