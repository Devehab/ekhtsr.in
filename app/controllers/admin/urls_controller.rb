class Admin::UrlsController < Admin::BaseController
  def a_urls_list
    @a_urls_list = AnonymousUrl.order(id: :desc).page(params[:page])
  end
  
  def destroy_a_url
    AnonymousUrl.find(params[:id]).destroy
    redirect_to admin_urls_a_urls_list_path, notice: 'تم حذف الرابط.'
  rescue
    redirect_to admin_urls_a_urls_list_path, alert: 'الرابط الذي تحاول حذفه غير موجود.'
  end
  
  def urls_list
    @urls_list = UserUrl.order(id: :desc).page(params[:page]).per(100)
  end
  
  def destroy_url
    UserUrl.find(params[:id]).destroy
    redirect_to admin_urls_urls_list_path, notice: 'تم حذف الرابط.'
  rescue
    redirect_to admin_urls_urls_list_path, alert: 'الرابط الذي تحاول حذفه غير موجود.'
  end
end