class PagesController < ApplicationController
  def index
    @anonymous_url = AnonymousUrl.new
    @message = Message.new
  end
  
  def privacy_policy
    
  end
  
  def terms_of_service
    
  end
  
  def sitemap
    
  end
end
