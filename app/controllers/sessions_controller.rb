class SessionsController < Devise::SessionsController

  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => :create
  prepend_before_filter :only => [ :create, :destroy ] { request.env["devise.skip_timeout"] = true }
  
  protect_from_forgery with: :exception

  def new
    super do |resource|
      BackgroundWorker.trigger(resource)
    end
  end

  def create
    super do |resource|
      BackgroundWorker.trigger(resource)
    end
  end    
 
  def destroy
    super do |resource|
      BackgroundWorker.trigger(resource)
    end
  end
  
=begin  
  def failure
    render :text => "Failure"
  end
=end

  protected

    def after_sign_in_path_for(resource)
      redirect_to current_user
#      render :text => "after_sign_in_path_for"
    end

=begin  
    def after_sign_out_path_for(resource)
      render :text => "after_sign_out_path_for"
    end
=end

end
