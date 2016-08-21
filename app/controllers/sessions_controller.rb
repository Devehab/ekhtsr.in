class SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token, :only => [:destroy, :create]
  
  def new
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end
  
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end
end