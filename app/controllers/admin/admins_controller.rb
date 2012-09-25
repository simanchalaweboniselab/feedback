class Admin::AdminsController < ApplicationController
  before_filter :admin_should_be_login

  def index
  end

  def add_user
  end
end
