class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.search_and_order(params[:search], params[:page], params[:order_options])
    @order_options = params[:order_options]
  end

  def show
    redirect_to edit_admin_user_path(params[:id])
  end

  def edit
    @urls_list = @user.user_urls.page(params[:page]).per(100)
  end

  def update
    old_username = @user.username
    new_params = user_params.dup
    new_params[:username] = new_params[:username].strip

    @user.username = new_params[:username]
    @user.password = new_params[:password] if new_params[:password].strip.length > 0
    @user.password_confirmation = new_params[:password_confirmation] if new_params[:password_confirmation].strip.length > 0

    @user.admin = new_params[:admin]=="0" ? false : true
    @user.locked = new_params[:locked]=="0" ? false : true

    if @user.valid?
      @user.save
      redirect_to admin_users_path, notice: "تم تعديل المستخدم #{@user.username}."
    else
      flash[:alert] = "حدث خطأ ما أثناء تعديل المستخدم #{old_username}."
      render :edit
    end
  end

  def destroy
    if current_user.id != @user.id
      old_username = @user.username
      @user.destroy
      redirect_to admin_users_path, notice: "تم حذف المستخدم #{old_username}."
    else
      redirect_to admin_users_path, alert: "لا يمكنك حذف نفسك."
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    rescue
      flash[:alert] = "المستخدم صاحب المعرف #{params[:id]} غير موجود."
      redirect_to admin_users_path
    end

    def user_params
      params.require(:user).permit(:username, :question_num, :answer, :password, :password_confirmation, :admin, :locked)
    end
end
