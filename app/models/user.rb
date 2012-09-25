class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :role
  acts_as_authentic
end
