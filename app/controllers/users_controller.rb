class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_user
  
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end  
  
  
  def validate_user
    redirect_to resource 
  end
end