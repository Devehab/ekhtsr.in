class RegistrationsController < Devise::RegistrationsController
  def new
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end
  
  def create
    if verify_recaptcha
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      sign_up(resource_name, resource)

      respond_to do |format|
        format.js { render "create" }
        format.html { redirect_to root_path }
      end
    else
      respond_to do |format|
        flash[:recaptcha_error] = 'لماذا لم تقم بالضغط على "أنا لست برنامج روبوت"؟ هل انتَ  روبوت فعلاً؟'
        format.js { render "invalid_captcha" }
        format.html { redirect_to root_path }
      end
    end
  rescue
    respond_to do |format|
      format.js { render "failur" }
      format.html { redirect_to root_path, 'خطأ في إدخال بيانات حسابك الجديد.' }
    end
  end
end