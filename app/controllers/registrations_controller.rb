class RegistrationsController < Devise::RegistrationsController

  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
    
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
=begin    
    build_resource(sign_up_params)
    resource.skip_confirmation!

    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end


    if resource.save
      sign_in resource
      render :text => "Created Registration"
#      redirect_to @user
    else
#      render :text => "Failure Registration"
      render :new
    end

=end
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

=begin
  protected
  
    def after_sign_up_path_for(resource)
      render :text => "after_sign_up_path_for"
    end
      
    def after_inactive_sign_up_path_for(resource)
      render :text => "after_inactive_sign_up_path_for"
    end
=end

end
      
