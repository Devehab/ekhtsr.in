class AnonymousUrl < ActiveRecord::Base
  validates :url, presence: :true
  
  paginates_per 100
  
  def self.last_urls(count)
    order(id: :desc).limit(count).all
  end

  def self.urls_count
    all.count
  end
end