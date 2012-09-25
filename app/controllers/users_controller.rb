class UsersController < ApplicationController
  before_filter :user_should_be_login

  def index

  end

end
