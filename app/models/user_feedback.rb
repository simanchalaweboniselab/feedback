require "execute"
class UserFeedback < ActiveRecord::Base
  extend Execute
  attr_accessible :feedback, :from_id, :to_id, :created_at

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

  def self.assign_feedback(params)
    record = []
    0..3.times do |i|
      weekday = DateTime.now.wday
      count = 0
      #self.create(:from_id => params[:from_user], :to_id => params["to_user_#{i}"])
      while(weekday <= 5)
        record << "(#{params[:from_user]}, #{params["to_user_#{i}"]}, '#{Time.now.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))+ (count*24*60*60 if count != 0).to_i}')"
        weekday = weekday + 1
        count = count + 1
      end
    end
    sql = "INSERT INTO user_feedbacks (from_id, to_id, created_at) VALUES #{record.join(", ")}"
    execute_query sql
    return true
  end

  def self.assigned_feedback(user, begin_date, end_date)
    user.from.where(:created_at => begin_date..end_date, :feedback => nil)
  end
  def self.given_feedback(user, begin_date, end_date)
    user.from.where("created_at BETWEEN '#{begin_date}' AND '#{end_date}' AND feedback is NOT NULL")
  end
  def self.received_feedback(user, begin_date, end_date)
    user.to.where("created_at BETWEEN '#{begin_date}' AND '#{end_date}' AND feedback is NOT NULL")
  end

  def self.alert_mail
    #feedbacks = self.where("created_at >=  '#{Time.now - (1*7*24*60*60)}' AND feedback is NULL")
    feedbacks = self.where(:created_at => Time.now.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata')).beginning_of_day..Time.now.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata')).end_of_day)
    users = User.where(:id => feedbacks.collect{|feedback| feedback.from_id}.uniq)
    users.each do |user|
      names = User.where(:id => feedbacks.collect{|feedback|feedback.to_id if feedback.from_id == user.id}).map(&:name).join(', ')
      UserMailer.alert_mail(user, names).deliver
    end
  end


end
