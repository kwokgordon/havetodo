class SessionsController < Devise::SessionsController

  protect_from_forgery with: :exception

  skip_before_filter :verify_authenticity_token,
  :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :text => "Create"
  end

  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user.update_column(:authentication_token, nil)
    render :text => "Destroy"
  end    
  
  def failure
    render :text => "Failure"
  end

end
