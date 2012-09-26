class UserFeedback < ActiveRecord::Base
  attr_accessible :feedback, :from_id, :to_id

  belongs_to :from, :class_name => User
  belongs_to :to, :class_name => User

  before_save :check_user

  def check_user
    if User.find(self.from_id).role == 'admin' || User.find(self.to_id).role == 'admin'
      return false;
    end
  end
end
