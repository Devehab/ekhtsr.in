class UserUrl < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  
  paginates_per 10
  
  validates :url, presence: :true
  
  validates :title, length: { maximum: 200 }
  validates_format_of :title, with: /\A[a-zA-Z0-9[ذضصثقفغعهخحجدشسيبلاتنمكطئءؤرﻻىةوزظﻹإﻷأﻵآًٌٍَُِْ][!@#\$\%^&*()-_=+\\\/`.,?{}\[\]:;'"~ ـ]]*\z/
  
  validates :password, length: { maximum: 100 }
  validates_format_of :password, with: /\A[a-zA-Z0-9]*\z/
  
  def self.last_urls(count)
    order(id: :desc).limit(count).all
  end

  def self.urls_count
    all.count
  end
end
