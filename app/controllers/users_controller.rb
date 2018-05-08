class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :show]
  before_action :correct_user, only: [:edit, :update, :show]

  def index
    @users = User.where(activated: true).paginate page: params[:page],
     per_page: Settings.validate.min_length_password
  end

  def new
    @user = User.new
  end

  def show

  end

  def create
    @user = User.new user_params
  	if @user.save
      log_in @user
      remember @user
      flash[:success] = t "wellcome"
      redirect_to @user
    else
      render :new
    end
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find_by(params[:id]).destroy
    flash[:success] = t "user_deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :email, :name, :password, :password_confirmation
  end

  def find_user_id
    @user = User.find_by_id params[:id]
  end

  def logged_in_user
    unless logged_in?
    store_location
    flash[:danger] = t "please_login"
    redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by_id params[:id]
    redirect_to(root_url) unless @user == current_user
  end
end
