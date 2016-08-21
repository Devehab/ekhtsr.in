class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :reject_locked!, if: :devise_controller?

  def reject_locked!
    if current_user && current_user.locked?
      sign_out current_user
      user_session = nil
      current_user = nil
      flash[:alert] = "تم قفل حسابك، راجع الإدارة لفهم الأسباب."
      flash[:notice] = nil
      redirect_to root_path
    end
  end
  helper_method :reject_locked!

  def require_admin!
    authenticate_user!

    if current_user && !current_user.admin?
      redirect_to root_path, alert: 'يجب أن تمتلك الصلاحيات لدخول هذه الصفحة.'
    end
  end
  helper_method :require_admin!
  
  def not_user!
    if user_signed_in?
      redirect_to root_path, alert: 'لا يمكنك إستخدام هذه الميزة.'
    end
  end
  helper_method :not_user!
  
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :password, :password_confirmation, :remember_me, :question_num, :answer) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:username, :password, :password_confirmation, :current_password, :question_num, :answer)}
    end
end