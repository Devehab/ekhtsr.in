class Admin::MessagesController < Admin::BaseController
  before_filter :set_message, only: [:show, :destroy]
  
  def index
    @messages_list = Message.order(id: :desc).page(params[:page])
  end
  
  def show
  end
  
  def destroy
    @message.destroy
    redirect_to admin_messages_path, notice: 'تم حذف الرسالة.'
  end
  
  private
    def set_message
      @message = Message.find(params[:id])
    rescue
      flash[:alert] = "الرسالة التي تحاول البحث عنها غير موجودة."
      redirect_to admin_messages_path
    end
end