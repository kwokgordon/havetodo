class User < ActiveRecord::Base

  # You likely have this before callback set up for the token.
#  before_save :ensure_authentication_token

=begin 
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
=end

  def need_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
      self.save
    end
  end
  
  def remove_authentication_token
    if !authentication_token.blank?
      self.authentication_token = nil
    end
  end
 
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :token_authenticatable

  validates :name, presence: true
  validates :email, presence: true


  def skip_confirmation!
    self.confirmed_at = Time.now
  end

  has_and_belongs_to_many :tasks
  has_and_belongs_to_many :tasklists
  
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user


  private
  
    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end

end
