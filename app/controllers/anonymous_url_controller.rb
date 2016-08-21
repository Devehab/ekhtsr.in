require 'securerandom'

class AnonymousUrlController < ApplicationController
  before_filter :not_user!, only: [:create]
  skip_before_filter :verify_authenticity_token, only: [:create]
  
  def create
    @anonymous_url = AnonymousUrl.new(anonymous_url_params)
    
    if !@anonymous_url.url.include?('ekhtsr') && ValidatesEmailFormatOf::validate_email_format(@anonymous_url.url) != nil
      @anonymous_url.unique_id = SecureRandom.urlsafe_base64(4)

      if !@anonymous_url.url.include?('http://') && !@anonymous_url.url.include?('https://')
        @anonymous_url.url = 'http://' + @anonymous_url.url
      end

      uri = URI.parse(@anonymous_url.url)
      uri.kind_of?(URI::HTTP)

      respond_to do |format|
        if @anonymous_url.save
          format.js { render "create" }
          format.html { redirect_to root_path, notice: ('ekhtsr.in/a/' + @anonymous_url.unique_id).to_s }
        else
          format.js { render "failur" }
          format.html { redirect_to root_path, alert: 'قمت بإدخال رابط خاطئ.' }
        end
      end
    else
      respond_to do |format|
        format.js { render "failur" }
        format.html { redirect_to root_path, alert: 'قمت بإدخال رابط خاطئ.' }
      end
    end
  rescue URI::InvalidURIError
    respond_to do |format|
      format.js { render "failur" }
      format.html { redirect_to root_path, alert: 'قمت بإدخال رابط خاطئ.' }
    end
  end
  
  def go
    @anonymous_url = AnonymousUrl.find_by_unique_id(params[:id])
    
    if @anonymous_url
      @anonymous_url.visit_counter += 1
      @anonymous_url.save
      redirect_to @anonymous_url.url
    else
      redirect_to root_path, alert: 'الرابط الذي تحاول الوصول إليه غير موجود.'
    end
  end
  
  private
    def anonymous_url_params
      params.require(:anonymous_url).permit(:url)
    end
end
