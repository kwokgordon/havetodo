class Api::TasksController < ApplicationController

  protect_from_forgery with: :null_session
  
  skip_before_filter :verify_authenticity_token,
  :if => Proc.new { |c| c.request.format == 'application/json' }

  # Just skip the authentication for now
  #before_filter :authenticate_user!

  #before_action :get_user
  #before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  respond_to :json

  def index
    @overdue_tasks = Task.all

=begin
    @new_task = Task.new
    @tasks = @user.tasks
    
    @overdue_tasks = @user.tasks.overdue_tasks
    @today_tasks = @user.tasks.today_tasks
    @tomorrow_tasks = @user.tasks.tomorrow_tasks
    @this_week_tasks = @user.tasks.this_week_tasks
    @future_tasks = @user.tasks.future_tasks
    @no_duedate_tasks = @user.tasks.no_duedate_tasks
    @completed_tasks = @user.tasks.completed_tasks
=end
  end

  def toggleComplete
    get_user
    @task = @user.tasks.find(params[:task_id])
    
    if !@task.completed
      @task.completed = true
      @task.completed_date = Time.now
      @task.completed_user_id = @user.id
    else
      @task.completed = false
      @task.completed_date = nil
      @task.completed_user_id = nil
    end
    
    if @task.save
      render :text => "Toggle Success"
    else
      render :text => "Toggle Failure"
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def get_user
      @user = User.find(current_user.id)
    end

    def set_task
      get_user
#      @task = Task.find(params[:id])
      @task = @user.tasks.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id)
    end

end
      
