class UsersController < ApplicationController
  before_filter :user_should_be_login, :only => [:index]
  before_filter :find_user_by_perishable_token, :only => [:new_password, :create_password]

  def index
  end
  def new_password
    if !@user
      redirect_to new_user_session_path
    end
  end
  def create_password
    if @user.update_attributes(params[:user])
      redirect_to new_user_session_path, :notice  => "password created successfully!!!!"
    else
      render :new_password
    end
  end

  protected
  def find_user_by_perishable_token
    @user = User.find_by_perishable_token(params[:id])
  end

end
