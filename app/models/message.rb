class Message < ActiveRecord::Base
  paginates_per 100
  
  validates :name   , presence: :true
  validates :name, length: { maximum: 100 }
  validates_format_of :name, with: /\A[a-zA-Z0-9[ذضصثقفغعهخحجدشسيبلاتنمكطئءؤرﻻىةوزظﻹإﻷأﻵآًٌٍَُِْ]\_\ ]*\z/
  
  validates :email  , presence: :true
  validates :email, length: { maximum: 100 }
  validates_email_format_of :email
  
  validates :content, presence: :true
  validates_format_of :content, with: /\A[a-zA-Z0-9[ذضصثقفغعهخحجدشسيبلاتنمكطئءؤرﻻىةوزظﻹإﻷأﻵآًٌٍَُِْ]\_\ \@\:\-\.]*\z/
  
  def self.last_messages(count)
    order(id: :desc).limit(count).all
  end

  def self.messages_count
    all.count
  end
end
