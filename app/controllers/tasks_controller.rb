class TasksController < ApplicationController

  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
                       
  before_filter :authenticate_user!
  before_filter :validate_user
  
  before_action :get_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
 
  # GET /tasks
  # GET /tasks.json
  def index
    @new_task = Task.new
#    @tasks = Task.all
    @tasks = @user.tasks

    @overdue_tasks = @user.tasks.overdue_tasks
    @today_tasks = @user.tasks.today_tasks
    @tomorrow_tasks = @user.tasks.tomorrow_tasks
    @this_week_tasks = @user.tasks.this_week_tasks
    @future_tasks = @user.tasks.future_tasks
    @no_duedate_tasks = @user.tasks.no_duedate_tasks
    @completed_tasks = @user.tasks.completed_tasks

  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
#    @task = @user.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
#    @task = @user.tasks.build(task_params)

    set_cookies
    
    respond_to do |format|
      if @task.save
        @user.tasks << @task
        
        format.html { redirect_to :action => :index }
#        format.html { redirect_to :action => :index, notice: "#{@task.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { redirect_to :action => :index }
#        format.html { redirect_to :action => :index, notice: "#{@task.name} was not created." }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to :action => :index }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  def validate_user
    redirect_to new_user_session_path unless current_user
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
    
    def set_cookies
      if cookies[:show_details] == "true"
        cookies[:note] = { value: @task.note, path: '/users' }
        cookies[:due_date] = { value: @task.due_date, path: '/users' }
        cookies[:due_time] = { value: @task.due_time, path: '/users' }
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id)
    end
end
