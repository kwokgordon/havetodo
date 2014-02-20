class WelcomeController < ApplicationController
  def index
  end
  
  def blank
    render :layout => true
  end
end
