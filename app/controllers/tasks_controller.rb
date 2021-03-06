class TasksController < ApplicationController
  
  layout 'tasklist'

  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
                       
  before_filter :authenticate_user!
  before_filter :validate_user
  
  before_action :get_user
  before_action :get_tasks
  before_action :get_tasklists
  before_action :share_tasklist
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @new_task = Task.new
#    @tasks = Task.all
    
#    @tasklists = @user.tasklists
    
#    @tasks = @user.tasks
    
    @overdue_tasks = @tasks.overdue_tasks.order(:due_date).order(:due_time).order(:name)
    @today_tasks = @tasks.today_tasks.order(:due_date).order(:due_time).order(:name)
    @tomorrow_tasks = @tasks.tomorrow_tasks.order(:due_date).order(:due_time).order(:name)
    @this_week_tasks = @tasks.this_week_tasks.order(:due_date).order(:due_time).order(:name)
    @future_tasks = @tasks.future_tasks.order(:due_date).order(:due_time).order(:name)
    
    @no_duedate_tasks = @tasks.no_duedate_tasks.order(:name)
    @completed_tasks = @tasks.completed_tasks.order(:completed_date).reverse_order

  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    share_task
  end

  # GET /tasks/new
  def new
    @task = Task.new
#    @task = @user.tasks.build
  end

  # GET /tasks/1/edit
  def edit
    share_task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
#    @task = @user.tasks.build(task_params)

    if params.has_key?(:tasklist_id)
      @tasklist = @user.tasklists.find(params[:tasklist_id])
      set_cookies_tasklist
    else
      set_cookies
    end
    
    respond_to do |format|
      if @task.save
        @user.tasks << @task
        
        if params.has_key?(:tasklist_id)
          @tasklist.tasks << @task
        end
                
        format.html { 
          flash[:success] = "#{@task.name} was successfully created." 
          redirect_to params.has_key?(:tasklist_id) ? @tasklist : tasks_path
#          redirect_to :action => :index
        }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { 
          flash[:danger] = "#{@task.name} was not created."
          redirect_to :action => :index
        }
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
    task_name = @task.name
    @task.destroy
    respond_to do |format|
      format.html { 
        flash[:success] = "#{task_name} was successfully deleted." 
        redirect_to params.has_key?(:tasklist_id) ? @tasklist : tasks_url
      }
      format.json { head :no_content }
    end
  end

  def validate_user
    redirect_to new_user_session_path unless current_user
  end

  def toggleComplete
#    get_user
    @task = @user.tasks.find(params[:task_id])
    
    if !@task.completed
      @task.completed = true
      @task.completed_date = Time.now
      @task.completed_user_id = @user.id
      @task.completed_user_name = @user.name
    else
      @task.completed = false
      @task.completed_date = nil
      @task.completed_user_id = nil
      @task.completed_user_name = nil
    end
    
    respond_to do |format|
      if @task.save
        format.html { render :text => "Toggle Success" }
        format.json { render :json=> {:success => true, :info => "Toggle Success", :data => {}} }
      else
        format.html { render :text => "Toggle Failure" }
        format.json { render :json=> {:success => false, :info => "Toggle Failure", :data => {}} }
      end
    end
  end
  
  def addFriend
    @friend = User.find(params[:user_id])
    @task = @user.tasks.find(params[:task_id])
    @task.users << @friend

    respond_to do |format|
      format.html { 
        flash[:success] = "Successfully shared task with #{@friend.name}" 
        redirect_to :back
      }
      format.json 
    end    
  end
  
  def removeFriend
    @friend = User.find(params[:user_id])
    @task = @user.tasks.find(params[:task_id])

    share_task

    respond_to do |format|
      if @friend == @user
        format.html { 
          flash[:danger] = "Cannot remove yourself." 
          redirect_to :back
        }
        format.json 
      elsif !@friends.include? @friend.id
        format.html { 
          flash[:danger] = "#{@friend.name} is not your friend, cannot remove from task." 
          redirect_to :back
        }
        format.json 
      else
        @task.users.delete(@friend)
        
        format.html { 
          flash[:success] = "#{@friend.name} successfully removed from task." 
          redirect_to :back
        }
        format.json 
      end
    end    
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def get_user
      @user = User.find(current_user.id)
    end

    def get_tasks
      @tasks = @user.tasks
    end
    
    def get_tasklists
      @tasklists = @user.tasklists.order(:name)
    end

    def set_task
      get_user
#      @task = Task.find(params[:id])
      @task = @user.tasks.find(params[:id])
    end
    
    def set_cookies
      if cookies[:show_details] == "true"
        cookies[:note] = { value: @task.note, path: '/users' }
#        cookies[:note] = { value: @task.note }
        if !@task.due_date.blank?
          cookies[:due_date] = { value: @task.due_date.strftime("%Y-%m-%d"), path: '/users' }
#          cookies[:due_date] = { value: @task.due_date.strftime("%Y-%m-%d") }
        end

        if !@task.due_time.blank?
          cookies[:due_time] = { value: @task.due_time.strftime("%H:%M:%S.%L"), path: '/users' }
#          cookies[:due_time] = { value: @task.due_time.strftime("%H:%M:%S.%L") }
        end
      end
    end

    def set_cookies_tasklist
      if cookies[:show_details] == "true"
        cookies[:note] = { value: @task.note, path: '/users/tasklists' }
        if !@task.due_date.blank?
          cookies[:due_date] = { value: @task.due_date.strftime("%Y-%m-%d"), path: '/users/tasklists' }
        end

        if !@task.due_time.blank?
          cookies[:due_time] = { value: @task.due_time.strftime("%H:%M:%S.%L"), path: '/users/tasklists' }
        end
      end
    end
    
    def share_task
      @friends = @user.friendships.accepted.pluck(:friend_id)
      @friends = @friends + @user.inverse_friendships.accepted.pluck(:user_id)
    
      @task_shared = @task.users.pluck(:id)
    end

    def share_tasklist
      @friends = @user.friendships.accepted.pluck(:friend_id)
      @friends = @friends + @user.inverse_friendships.accepted.pluck(:user_id)
    
#      @tasklist_shared = @tasklist.users.pluck(:id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id, :completed_user_name)
    end
end
