class UserFeedback < ActiveRecord::Base
  attr_accessible :feedback, :from_id, :to_id

  belongs_to :from, :class_name => User
  belongs_to :to, :class_name => User

  before_save :check_user

  validates :feedback, :length => { :maximum => 50 }
  validates :from_id, :to_id, :presence => true

  def check_user
    if User.find(self.from_id).role == 'admin' || User.find(self.to_id).role == 'admin'
      return false;
    end
  end

  def self.alert_mail
    #feedbacks = self.where("created_at >=  '#{Time.now - (1*7*24*60*60)}' AND created_at =  updated_at")
    feedbacks = self.where("created_at >=  '#{Time.now - (1*7*24*60*60)}' AND feedback is NULL")
    users = User.where(:id => feedbacks.collect{|feedback| feedback.from_id}.uniq)
    users.each do |user|
      names = User.where(:id => feedbacks.collect{|feedback|feedback.to_id if feedback.from_id == user.id}).map(&:name).join(', ')
      #UserMailer.alert_mail(user, names).deliver
    end
  end
end
