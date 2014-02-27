class StayawakeController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    render :text => ""
  end
end
