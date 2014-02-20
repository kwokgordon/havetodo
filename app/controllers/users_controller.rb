class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_user
  
  def show
    redirect_to tasks_path
  end
  
  def validate_user
    redirect_to new_user_session_path unless current_user
  end
end
