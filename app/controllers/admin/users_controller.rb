class Admin::UsersController < ApplicationController
  before_filter :admin_should_be_login
  before_filter :find_user, :only => [:to_feedback, :from_feedback, :assigned_feedback]

  def index
    @users =  User.where(:role => "user").paginate(:page => params[:page], :per_page => 10)
  end
  def assign_user
    @users = User.where(:role => "user")
  end

  def get_from_user_list
    @feedback = UserFeedback.where("created_at >=  '#{Time.now - (1*7*24*60*60)}'")
    feedback = @feedback.collect{|f| f.from_id}.zip(params[:from_user] ? params[:from_user] : []).flatten.compact.collect{|s| s.to_i}
    @users = User.where("id not in(?) and role = 'user'", feedback.present? ? feedback : '' )
    render :json => @users
  end

  def get_to_user_list
    @users = User.where("id not in(?) and role = 'user'", params[:from_user])
    render :json => @users
  end

  def create_assign_user
    if UserFeedback.assign_feedback(params)
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end
  end

  def to_feedback
    @feedbacks =  @user.to.paginate(:page => params[:page], :per_page => 10).order('updated_at desc')
  end

  def from_feedback
    @feedbacks =  @user.from.paginate(:page => params[:page], :per_page => 10).order('created_at desc')
  end

  def assigned_feedback
    @feedbacks = @user.from.where(:feedback => nil).paginate(:page => params[:page], :per_page => 10).order('created_at desc')
  end
  def assigned_search
    logger.info "======================#{params.inspect}"
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end
end
