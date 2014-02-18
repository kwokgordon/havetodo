class SessionsController < Devise::SessionsController

#  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
#  prepend_before_filter :allow_params_authentication!, :only => :create
#  prepend_before_filter :only => [ :create, :destroy ] { request.env["devise.skip_timeout"] = true }
  
  protect_from_forgery with: :exception

=begin
  def create
#    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :text => "Create"
  end

  def destroy
#    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
#    current_user.update_column(:authentication_token, nil)
    render :text => "Destroy"
  end    
 
  def destroy
    render 
  end
  
  def failure
    render :text => "Failure"
  end
=end

  protect
  
    def after_sign_in_path_for(resource)
      render :text => "after_sign_in_path_for"
    end

    def after_sign_out_path_for(resource)
      render :text => "after_sign_out_path_for"
    end

end
