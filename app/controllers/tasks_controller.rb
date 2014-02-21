class TasksController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :validate_user
  
  before_action :get_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  # Set Task Scope
  def self.default_scope
    get_user
    @user.tasks
  end
  
  scope :overdue_tasks, -> { where.not("due_date IS NULL").where("due_date <= ?", Time.now.midnight) }
  scope :today_tasks, -> { where.not("due_date IS NULL").where(due_date: (Time.now.midnight)..(Time.now.midnight + 1.day)) }
  scope :tomorrow_tasks, -> { where.not("due_date IS NULL").where(due_date: (Time.now.midnight + 1.day)..(Time.now.midnight + 2.day)) }
  scope :this_week_tasks, -> { where.not("due_date IS NULL").where(due_date: (Time.now.midnight + 2.day)..(Time.now.midnight + 7.day)) }
  scope :future_tasks, -> { where.not("due_date IS NULL").where("due_date >= ?", (Time.now.midnight + 7.day)) }
  scope :no_duedate_tasks, -> { where("due_date IS NULL") }


  # GET /tasks
  # GET /tasks.json
  def index
    @new_task = Task.new
#    @tasks = Task.all
    @tasks = Task.all
    
    @overdue_tasks = Task.all.overdue_tasks
    @today_tasks = Task.all.today_tasks
    @tomorrow_tasks = Task.all.tomorrow_tasks
    @this_week_tasks = Task.all.this_week_tasks
    @future_tasks = Task.all.future_tasks
    @no_duedate_tasks = Task.all.no_duedate_tasks

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
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
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
      params.require(:task).permit(:name, :note, :due_date, :completed, :completed_date)
    end
end
