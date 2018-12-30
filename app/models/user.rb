class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  attr_accessor :full_name, :age, :total_posts, :birthdays_this_month

  email_regex = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
  validates :email, :presence => true, :uniqueness => true, :format => email_regex
  validates :password, format: { with: /(?=.*?[0-9])(?=.*?[A-Za-z]).+/,
      message: "Password must contain at least one digit and one letter" }, length: { in: 6..10 }, on: :create

  validates :password, format: { with: /(?=.*?[0-9])(?=.*?[A-Za-z]).+/,
          message: "Password must contain at least one digit and one letter" }, length: { in: 6..10 }, on: :update, if: :password_digest_changed?

  has_secure_password


  #enum role: [:standard, :admin]
  require 'carrierwave'
  require 'carrierwave/orm/activerecord'
  mount_uploader :avatar, ImageUploader



  def self.find_or_create_from_auth_hash(auth)
  		where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
  			user.provider = auth.provider
  			user.uid = auth.uid
  			user.first_name = auth.info.first_name
  			user.last_name = auth.info.last_name
        user.nickname = auth.info.name
  			user.email = auth.info.email
  			user.remote_avatar_url = auth.info.image
        user.password = user.password_confirmation = '1' +SecureRandom.urlsafe_base64(n=6, false)
  			user.save!
  		end
  	end

  def full_name
    [self.first_name, self.last_name].join(" ") if !self.first_name.blank? && !self.last_name.blank?
  end

  def age
    ((Time.now - self.birth_day.to_time) / 1.year.seconds).floor
  end

  def total_tasks
    self.tasks.size
  end

  def uncompleted_tasks
    self.tasks.size - self.tasks.where(completed: true).size
  end


  def birthday_today?
    return nil unless self.birth_day?
    Date.today.strftime('%m%d') == self.birth_day.strftime('%m%d')
  end

  def self.birthdays_this_month
    User.where("cast(strftime('%m', birth_day) as int) = ?", Date.today.month).limit(10).order(Arel.sql('date(birth_day)'))
  end

  def self.birthdays_today
    User.where("strftime('%m%d', birth_day) = ?", Date.today.strftime('%m%d'))
  end
end
