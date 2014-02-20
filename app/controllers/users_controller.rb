class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_user
  
  def show
    @user = User.find(current_user.id)

    respond_to do |format|
      format.html { redirect_to tasks_path }
      format.json { render json: @user }
    end
    
  end  
  
  def validate_user
    redirect_to new_user_session_path unless current_user
  end
end
