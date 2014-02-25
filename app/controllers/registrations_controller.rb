class RegistrationsController < Devise::RegistrationsController

  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
    
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


  def cancel
    super do |resource|
      BackgroundWorker.trigger(resource)
    end
  end

  def update
    super do |resource|
      BackgroundWorker.trigger(resource)
    end
  end

  def edit
    super do |resource|
      BackgroundWorker.trigger(resource)
    end
  end

  def destroy
    super do |resource|
      BackgroundWorker.trigger(resource)
    end
  end

  protected
  
    def after_sign_up_path_for(resource)
      users_path(resource)
    end
      
=begin
    def after_inactive_sign_up_path_for(resource)
      render :text => "after_inactive_sign_up_path_for"
    end
=end

end
      
