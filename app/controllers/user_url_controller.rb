require 'securerandom'

class UserUrlController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create, :edit, :update, :destroy]
  before_action :set_user_url, only: [:edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:create]
  layout 'password', only: [:password]
  
  def index
    @user_url = UserUrl.new
    @user_urls = current_user.user_urls.order(id: :desc).page(params[:page])
  end
  
  def create
    @user_url = current_user.user_urls.new(user_url_params)
    
    if !@user_url.url.include?('ekhtsr') && ValidatesEmailFormatOf::validate_email_format(@user_url.url) != nil
      @user_url.unique_id = SecureRandom.urlsafe_base64(4)

      if !@user_url.url.include?('http://') && !@user_url.url.include?('https://')
        @user_url.url = 'http://' + @user_url.url
      end

      uri = URI.parse(@user_url.url)
      uri.kind_of?(URI::HTTP)

      respond_to do |format|
        if @user_url.save
          format.js { render "create" }
          format.html { redirect_to dashboard_path, notice: ('ekhtsr.in/' + @user_url.unique_id).to_s }
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
  
  def edit
    redirect_to dashboard_path, alert: "ﻻ يمكنك التعديل على روابط غيرك." if current_user.id != @user_url.user_id
  end
  
  def update
    if current_user.id != @user_url.user_id
      redirect_to dashboard_path, alert: "ﻻ يمكنك التعديل على روابط غيرك."
    else
      if !params[:user_url][:url].include?('http://') && !params[:user_url][:url].include?('https://')
        params[:user_url][:url] = 'http://' + params[:user_url][:url]
      end

      respond_to do |format|
        if @user_url.update(user_url_params)
          format.html { redirect_to dashboard_path, notice: 'تم التعديل على رابطك.' }
        else
          format.html { render :edit }
          format.json { render json: @user_url.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def destroy
    respond_to do |format|
      if current_user.id == @user_url.user_id && @user_url.destroy
        format.js { render "destroy" }
        format.html { redirect_to dashboard_path, notice: 'تم حذف الرابط بنجاح.' }
      else
        format.html { redirect_to dashboard_path, alert: 'لا يمكنك حذف روابط غيرك.' }
      end
    end
  end
  
  def go
    @user_url = UserUrl.find_by_unique_id(params[:id])
    
    if @user_url
      if @user_url.password.blank?
        @user_url.visit_counter += 1
        @user_url.save
        redirect_to @user_url.url
      else
        redirect_to action: :password, id: @user_url.unique_id
      end
    else
      redirect_to root_path, alert: 'الرابط الذي تحاول الوصول إليه غير موجود.'
    end
  end
  
  def password
  end
  
  def password_go
    @user_url = UserUrl.find_by_unique_id(params[:id])
    
    if params[:password] == @user_url.password
      @user_url.visit_counter += 1
      @user_url.save
      redirect_to @user_url.url
    else
      redirect_to action: :password, id: @user_url.unique_id
    end
  end
  
  private
    def user_url_params
      params.require(:user_url).permit(:url, :password, :title)
    end
  
    def set_user_url
      @user_url = UserUrl.find(params[:id])
    rescue
      redirect_to dashboard_path, alert: "الرابط الذي تبحث عنه غير موجود."
    end
end
