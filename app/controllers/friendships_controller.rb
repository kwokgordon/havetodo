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
    
    @friendships_request = @user.friendships.requested
    @inverse_friendships_request = @user.inverse_friendships.requested

    @friendships = @user.friendships.accepted
    @inverse_friendships = @user.inverse_friendships.accepted
    
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
          flash[:danger] = "#{params[:email]} not found, an invite is sent to #{params[:email]}"
          UserMailer.invite_friend(@user, params[:email]).deliver 
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
    find_friendship(params[:id])

    @friendship.destroy

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

    @friendship.status = "accepted"

    respond_to do |format|
      if @friendship.save
        format.html {
          flash[:success] = "You are now friend with #{@friend_name}" 
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

    @friendship.destroy

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
    
    def find_friendship(id)
      @friendship = @user.friendships.where(id: id).first
    
      if @friendship.nil?
        @friendship = @user.inverse_friendships.where(id: id).first
        @friend = @friendship.user
        @friend_name = @friendship.user.name
      else
        @friend = @friendship.friend
        @friend_name = @friendship.friend.name
      end

    end
end