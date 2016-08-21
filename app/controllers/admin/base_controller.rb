class Admin::BaseController < ApplicationController
  before_filter :require_admin!

  def index
    @last_signups = User.last_signups(10)
    @last_signins = User.last_signins(10)
    @users_count = User.users_count
    @admins = User.admins
    
    @last_a_urls = AnonymousUrl.last_urls(10)
    @a_urls_count = AnonymousUrl.urls_count
    
    @last_urls = UserUrl.last_urls(10)
    @urls_count = UserUrl.urls_count
    
    @last_messages = Message.last_messages(10)
    @messages_count = Message.messages_count
  end
end