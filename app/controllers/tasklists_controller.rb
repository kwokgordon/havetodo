class TasklistsController < ApplicationController

  layout 'tasklist', only: [:index, :show]

  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
                       
  before_filter :authenticate_user!
  before_filter :validate_user
  
  before_action :get_user
#  before_action :set_task, only: [:show, :edit, :update, :destroy]

  before_action :set_tasklist, only: [:show, :edit, :update, :destroy]

  # GET /tasklists
  # GET /tasklists.json
  def index
#    @tasklists = Tasklist.all
    @tasklists = @user.tasklists
  end

  # GET /tasklists/1
  # GET /tasklists/1.json
  def show
#    @new_task = Task.new
    @new_task = @user.tasks.build
#    @task = @user.tasks.build(task_params)

    share_task

    @tasklists = @user.tasklists

    @tasks = @tasklist.tasks
    
    @overdue_tasks = @tasks.overdue_tasks.order(:due_date).order(:due_time).order(:name)
    @today_tasks = @tasks.today_tasks.order(:due_date).order(:due_time).order(:name)
    @tomorrow_tasks = @tasks.tomorrow_tasks.order(:due_date).order(:due_time).order(:name)
    @this_week_tasks = @tasks.this_week_tasks.order(:due_date).order(:due_time).order(:name)
    @future_tasks = @tasks.future_tasks.order(:due_date).order(:due_time).order(:name)
    
    @no_duedate_tasks = @tasks.no_duedate_tasks.order(:name)
    @completed_tasks = @tasks.completed_tasks.order(:completed_date).reverse_order
    
  end

  # GET /tasklists/new
  def new
    @tasklist = Tasklist.new
  end

  # GET /tasklists/1/edit
  def edit
  end

  # POST /tasklists
  # POST /tasklists.json
  def create
    @tasklist = Tasklist.new(tasklist_params)

    respond_to do |format|
      if @tasklist.save
        @user.tasklists << @tasklist
        
        format.html { redirect_to @tasklist, notice: 'Tasklist was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tasklist }
      else
        format.html { render action: 'new' }
        format.json { render json: @tasklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasklists/1
  # PATCH/PUT /tasklists/1.json
  def update
    respond_to do |format|
      if @tasklist.update(tasklist_params)
        format.html { redirect_to @tasklist, notice: 'Tasklist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tasklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasklists/1
  # DELETE /tasklists/1.json
  def destroy
    @tasklist.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path }
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

    # Use callbacks to share common setup or constraints between actions.
    def set_tasklist
      get_user

#      @tasklist = Tasklist.find(params[:id])
      @tasklist = @user.tasklists.find(params[:id])
    end

    def share_task
      @friends = @user.friendships.accepted.pluck(:friend_id)
      @friends = @friends + @user.inverse_friendships.accepted.pluck(:user_id)
    
      @tasklist_shared = @tasklist.users.pluck(:id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tasklist_params
      params.require(:tasklist).permit(:name)
    end
end
