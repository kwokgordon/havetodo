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
    
    @friendships_request = @user.friendships.where(:status => "requested")
    @inverse_friendships_request = @user.inverse_friendships.where(:status => "requested")

    @friendships = @user.friendships.where(:status => "accepted")
    @inverse_friendships = @user.inverse_friendships.where(:status => "accepted")
    
    @all_friends = @friendships + @inverse_friendships
    
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
      @friendship = @user.friendships.build(:friend_id => @friend_id.first.id, :status => "requested")
      
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
  end
  
  def destroy
    get_user
    find_friendship(params[:friendship_id])

    @friend.destroy

    respond_to do |format|
      format.html {
        flash[:success] = "You removed #{@friend_name}" 
        redirect_to :action => :index
      }
      format.json 
    end  
  end
  
  def acceptFriend
    get_user
    find_friendship(params[:friendship_id])

    @friend.status = "accepted"

    respond_to do |format|
      if @friend.save
        format.html {
          flash[:success] = "You are now friend with #{@friend.user.name}" 
          redirect_to :action => :index
        }
        format.json 
      else
        format.html {
          flash[:danger] = "Something Wrong when accepting your friend" 
          redirect_to :action => :index
        }
        format.json 
      end
    end 
  end
  
  def rejectFriend
    get_user
    find_friendship(params[:friendship_id])

    @friend.destroy

    respond_to do |format|
      format.html {
        flash[:success] = "You rejected #{@friend_name}" 
        redirect_to :action => :index
      }
      format.json 
    end    
  end
  
  def removeFriend
  
  end

  def validate_user
    redirect_to new_user_session_path unless current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_user
      @user = User.find(current_user.id)
    end
    
    def find_friendship(f_id)
      @friend = @user.inverse_friendships.where(user_id: f_id, friend_id: @user.id).first
    
      if @friend.nil?
        @friend = @user.friendships.where(user_id: @user.id, friend_id: f_id).first
        @friend_name = @friend.friend.name
      end

      @friend_name = @friend.user.name
    end
end
