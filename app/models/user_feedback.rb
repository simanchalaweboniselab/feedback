class UserFeedback < ActiveRecord::Base
  attr_accessible :feedback, :from_user_id, :to_user_id

  belongs_to :from, :class_name => User
  belongs_to :to, :class_name => User
end
