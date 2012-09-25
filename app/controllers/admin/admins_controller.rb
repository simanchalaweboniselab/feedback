class Admin::AdminsController < ApplicationController
  before_filter :admin_should_be_login

  def index
  end

  def add_user
    @user = User.new
  end

  def create_user
    @user = User.create_user(params[:email], params[:name])
    if @user.valid?
      UserMailer.set_password(@user).deliver
      redirect_to root_path, :notice => "User created successfully!!!!!!!!!!"
    else
      render :add_user
    end
    #user = User.create(:name => params[:name], :email => params[:email], :password => )
  end
end
