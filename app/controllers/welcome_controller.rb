class WelcomeController < ApplicationController
  def index
    if current_user
      redirect_to tasks_path
    else
      respond_to do |format|
        format.html 
      end
    end
  end
  
  def blank
  end
end
