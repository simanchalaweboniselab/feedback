class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :role, :password_confirmation
  acts_as_authentic

  has_many :from, :class_name => UserFeedback, :foreign_key => :from_id
  has_many :to, :class_name => UserFeedback, :foreign_key => :to_id

  validates :name, :email, :password, :presence => true;
  validates :password, :length => {:minimum => 4}

  def self.create_user(email, name)
    password = SecureRandom.base64(15).tr('+/=', '').strip.delete("\n")
    self.create(:email => email, :name => name, :password => password, :password_confirmation => password)
  end

  def self.user_mail
    @users = self.where(:role => "user")
    @users.each do |user|
      UserMailer.demo(user).deliver
    end
  end
end
