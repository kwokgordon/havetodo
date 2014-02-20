class User < ActiveRecord::Base
  before_save :ensure_authentication_token

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :token_authenticatable

  validates :name, presence: true

  def skip_confirmation!
    self.confirmed_at = Time.now
  end

  has_many :tasks, :dependent => destroy
end
