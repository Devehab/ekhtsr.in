class PasswordsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:get_question_num]
  
  def edit
  end
  
  def update
    if verify_recaptcha
      @user = User.find_by_username(params[:username])

      respond_to do |format|
        if @user && @user.answer == params[:answer] && @user.update(user_params)
          format.html { redirect_to root_path, notice: 'تم تغيير كلمة مرورك بنجاح، يمكنك تسجيل الدخول.' }
        else
          format.html { redirect_to users_password_edit_path, alert: 'قمت بإدخال بيانات خاطئة.' }
        end
      end
    else
      respond_to do |format|
        flash[:recaptcha_error] = 'لماذا لم تقم بالضغط على "أنا لست برنامج روبوت"؟ هل انتَ  روبوت فعلاً؟'
        format.html { redirect_to users_password_edit_path }
      end
    end
  end
  
  def get_question_num
    @user = User.find_by_username(params[:username])
    
    if @user
      respond_to do |format|
        case @user.question_num
          when 1  then @question = 'ما هو اسم أول مدرس أعطاك علامة الرسوب؟'
          when 2  then @question = 'ما هو المكان الذي تم عقد زفافك فيه؟'
          when 3  then @question = 'ما هي أقرب بلدة يعيش فيها قريب لك؟'
          when 4  then @question = 'في أي وقت من اليوم ولِدت؟'
          when 5  then @question = 'ما هو لقبك في الطفولة؟'
          when 6  then @question = 'ما هي الدولة أو المدينة التي عملت فيها لأول مرة؟'
          when 7  then @question = 'ما هو الرقم الثالث والخامس والسابع من رقم هاتفك؟'
          when 8  then @question = 'من كان بطل طفولتك؟'
          when 9  then @question = 'ما هو أفضل موقع تستخدمه؟'
          when 10 then @question = 'ما هو رقم جواز سفرك؟'
        end
        
        format.js { render :get_question_num }
        format.html { redirect_to users_password_edit_path }
      end
    else
      respond_to do |format|
        format.js { render :failur }
        format.html { redirect_to users_password_edit_path, alert: 'قمت بإدخال اسم مستخدم خاطئ.' }
      end
    end
  end
  
  private
    def user_params
      params.permit(:password, :password_confirmation)
    end
end