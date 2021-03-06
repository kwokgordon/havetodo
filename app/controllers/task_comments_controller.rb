class TaskCommentsController < ApplicationController

  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
                       
  before_filter :authenticate_user!
  before_filter :validate_user

  before_action :get_user
  before_action :get_task
  before_action :get_task_comments
  

  before_action :set_task_comment, only: [:show, :edit, :update, :destroy]

  # GET /task_comments
  # GET /task_comments.json
  def index
#    @task_comments = TaskComment.all
  end

  # GET /task_comments/1
  # GET /task_comments/1.json
  def show
  end

  # GET /task_comments/new
  def new
    @task_comment = TaskComment.new
  end

  # GET /task_comments/1/edit
  def edit
  end

  # POST /task_comments
  # POST /task_comments.json
  def create
    @task_comment = TaskComment.new(task_comment_params)

    respond_to do |format|
      if @task_comment.save
        format.html { 
          flash[:success] = "Task Comment was successfully added." 
          redirect_to @task
        }
        format.json { render action: 'show', status: :created, location: @task_comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @task_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_comments/1
  # PATCH/PUT /task_comments/1.json
  def update
    respond_to do |format|
      if @task_comment.update(task_comment_params)
        format.html { 
          flash[:success] = "Task comment was successfully updated." 
          redirect_to @task
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_comments/1
  # DELETE /task_comments/1.json
  def destroy
    @task_comment.destroy
    respond_to do |format|
      format.html { 
          flash[:success] = "Task comment was successfully deleted." 
          redirect_to @task
      }
      format.json { head :no_content }
    end
  end

  def validate_user
    redirect_to new_user_session_path unless current_user
  end


  private
    def get_user
      @user = User.find(current_user.id)
    end
    
    def get_task
      @task = @user.tasks.find(params[:task_id])
    end
    
    def get_task_comments
      @task_comments = @task.task_comments
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task_comment
      @task_comment = @task.task_comments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_comment_params
      params.require(:task_comment).permit(:task_id, :user_id, :user_name, :comment)
    end
end
