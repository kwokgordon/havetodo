class Tasklist < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :tasks
  
  attr_accessible :name, :color

  validates :name, presence: true
  validates :color, presence: true

=begin
  def to_param
    "#{id}-#{name}"
  end
=end

end
