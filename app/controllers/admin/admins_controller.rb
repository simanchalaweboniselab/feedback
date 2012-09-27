class Admin::AdminsController < ApplicationController
  before_filter :admin_should_be_login
  before_filter :find_user, :only => [:to_feedback, :from_feedback]

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

  def assign_user
    @users = User.where(:role => "user")
  end
  def user_list
    @users =  User.where(:role => "user")
  end

  def to_feedback
    @feedbacks =  @user.to
  end

  def from_feedback
    @feedbacks =  @user.from
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end
end
