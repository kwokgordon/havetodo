class RegistrationsController < Devise::RegistrationsController
  
  protect_from_forgery with: :exception

  def new
    @user = User.new
  end
  
  def create
    build_resource(sign_up_params)
    resource.skip_confirmation!

    if resource.save
      sign_in resource
      render :text => "Created Registration"
#      redirect_to @user
    else
#      render :text => "Failure Registration"
      render :new
    end
  end


=begin
  def cancel
    
  end

  def update
    
  end

  def edit
    render :edit
  end
=end

  protected
  
    def sign_up_params
      devise_parameter_sanitizer.sanitize(:user)
    end
  
    def after_sign_up_path_for(resource)
      render :text => "after_sign_up_path_for"
    end
      
    def after_inactive_sign_up_path_for(resource)
      render :text => "after_inactive_sign_up_path_for"
    end
end
      
