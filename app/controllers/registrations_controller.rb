class RegistrationsController < Devise::RegistrationsController
  
  protect_from_forgery with: :exception

  def new
    @user = User.new

  end
  
  def create
    @user = User.new(params[:user])
    
    build_resource(params[:user])
    resource.skip_confirmation!

    if resource.save
      sign_in resource
      render :text => "Created Registration"
#      redirect_to @user
    else
      render :text => "Failure Registration"
#      render 'new'
    end
  end

  def cancel
    
  end

  def update
    
  end

  def edit
    
  end

end
      
