class RegistrationsController < Devise::RegistrationsController
  
  protect_from_forgery with: :exception

  skip_before_filter :verify_authenticity_token,
  :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

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
      
