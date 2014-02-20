class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_user
  
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end  
  
  
  def validate_user
    puts "current_user: " + current_user.id.to_s
    puts "params[:id]: " + params[:id].to_s

    redirect_to root_path unless current_user and current_user.id == params[:id]
  end
end