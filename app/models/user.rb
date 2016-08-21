class User < ActiveRecord::Base
  has_many :user_urls
  
  paginates_per 100
  
  # Include default devise modules. Others available are:
  # :confirmable, :recoverable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]
  
  # Validations
  # :username
    validates :username, presence: :true
    validates :username, uniqueness: { case_sensitive: false }
    validates_format_of :username, with: /\A[a-zA-Z0-9[ذضصثقفغعهخحجدشسيبلاتنمكطئءؤرﻻىةوزظﻹإﻷأﻵآًٌٍَُِْ]\_\ ]*\z/
    validates :username, length: { in: 3..16 }
  
  # :question_num
    validates :question_num, presence: :true
    validates :question_num, inclusion: { in: (1..10) }
  
  # :answer
    validates :answer, presence: :true
    validates :answer, length: { maximum: 50 }
    validates_format_of :answer, with: /\A[a-zA-Z0-9[ذضصثقفغعهخحجدشسيبلاتنمكطئءؤرﻻىةوزظﻹإﻷأﻵآًٌٍَُِْ]\_\ \@\:\-\.\#\!\$\%\^\&\*\(\)]*\z/
  
  def self.search_and_order(search, page_number, order_options)
    if search
      where("username LIKE ? AND admin = ?","%#{search.downcase}%",false).order(
      admin: :desc, username: :asc
      ).page page_number
    else
      case order_options
        when "order_by_id"
          where("admin = ?",false).order(id: :desc).page page_number
        when "order_by_username"
          where("admin = ?",false).order(username: :desc).page page_number
        when "order_by_sign_in_count"
          where("admin = ?",false).order(sign_in_count: :desc).page page_number
        when "order_by_last_sign_in_at"
          where("admin = ?",false).order(last_sign_in_at: :desc).page page_number
      when "order_by_user_urls_count"
          where("admin = ?",false).order(user_urls_count: :desc).page page_number
        else
          where("admin = ?",false).order(id: :desc).page page_number
      end
    end
  end
  
  def self.last_signups(count)
    order(created_at: :desc).limit(count).select("id","username","created_at")
  end

  def self.last_signins(count)
    order(last_sign_in_at: :desc).limit(count).select("id","username","last_sign_in_at")
  end

  def self.users_count
    where("admin = ? AND locked = ?",false,false).count
  end

  def self.admins
    where("admin = ?",true).order(id: :asc)
  end
  
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
