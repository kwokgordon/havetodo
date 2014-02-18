class RegistrationsController < Devise::RegistrationsController
  
  protect_from_forgery with: :exception

  def create
    build_resource(params[:user])
    resource.skip_confirmation!
    
    if resource.save
      sign_in resource
      render :text => "Created Registration"
    else
      render :text => "Failure Registration"
    end
  end

end
      
