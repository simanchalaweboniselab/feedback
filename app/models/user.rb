class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :role, :password_confirmation
  acts_as_authentic

  has_many :from_feedbacks, :class_name => UserFeedback, :foreign_key => :from_user_id
  has_many :to_feedbacks, :class_name => UserFeedback, :foreign_key => :to_user_id

  validates :name, :email, :password, :presence => true;

  def self.create_user(email, name)
    password = SecureRandom.base64(15).tr('+/=', '').strip.delete("\n")
    self.create(:email => email, :name => name, :password => password, :password_confirmation => password)
  end
end
