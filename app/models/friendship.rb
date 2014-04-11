class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  scope :requested, -> { where(status: "requested") }
  scope :accepted, -> { where(status: "accepted") }

  attr_accessible :user_id, :friend_id, :status
  
  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :status, presence: true
  
end