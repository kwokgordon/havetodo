class Api::TasksController < ApplicationController

  protect_from_forgery with: :null_session
  
  skip_before_filter :verify_authenticity_token,
  :if => Proc.new { |c| c.request.format == 'application/json' }

  # Just skip the authentication for now
  # before_filter :authenticate_user!

  respond_to :json

  def index
    render "/users/tasks.json"
  end

end
      
