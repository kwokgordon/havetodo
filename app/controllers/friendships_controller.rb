class FriendshipsController < ApplicationController

  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
                       
  before_filter :authenticate_user!
  before_filter :validate_user
  
  before_action :get_user


  # GET /friendships
  # GET /friendships.json
  def index
#    @new_friend = Friendship.new
    
    @friends = @user.friendships
    
    respond_to do |format|
      format.html 
      format.json 
    end
  end

  def create
    @friend_id = User.where(:email => params[:email])
    
    if @friend_id.empty?
      respond_to do |format|
        format.html {
          flash[:danger] = "#{params[:email]} not found" 
          redirect_to :action => :index
        }
#        format.json { render json: params[:email], status: :unprocessable_entity }
      end
    else
      @friendship = @user.friendships.build(:friend_id => @friend_id.first.id, :status => "request")
      
      respond_to do |format|
        if @friendship.save
          format.html {
            flash[:success] = "#{params[:email]} was successfully requested." 
            redirect_to :action => :index
          }
        else
          format.html {
            flash[:danger] = "#{@task.name} was not created."
            redirect_to :action => :index
          }
        end
      end
    end
    
=begin    
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = "Added friend."
      redirect_to :action => :index
    else
      flash[:error] = "Unable to add friend."
      redirect_to root_url
    end
=end
  end
  
  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_to current_user
  end

  def validate_user
    redirect_to new_user_session_path unless current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_user
      @user = User.find(current_user.id)
    end
end
