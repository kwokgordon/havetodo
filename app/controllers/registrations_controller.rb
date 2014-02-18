class RegistrationsController < Devise::RegistrationsController
  
  protect_from_forgery with: :exception

  def new
    @user = User.new

  end
  
  def create
    @user = User.new(params[:user])
    
    build_resource(params[:user])
    resource.skip_confirmation!

    render :text => "Created Registration"

=begin
    build_resource(params[:user])
    resource.skip_confirmation!
    
    if resource.save
      sign_in resource
      render :text => "Created Registration"
    else
      render :text => "Failure Registration"
    end
=end
  end

end
      
