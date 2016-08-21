class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    @message = Message.new(message_params)
    
    respond_to do |format|
      if @message.save
        format.js { render "create" }
        format.html { redirect_to root_path, notice: 'تم التوصّل برسالتك بنجاح.' }
      else
        format.js { render "failur" }
        format.html { redirect_to root_path, notice: 'حدث خطأ أثناء إرسال الرسالة.' }
      end
    end
  end
  
  private
    def message_params
      params.require(:message).permit(:name, :email, :content)
    end
end
