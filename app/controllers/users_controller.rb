class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find params[:id]
  end

  def create
  	@user = User.new user_params
  	if @user.save
      log_in @user
      remember @user
      flash[:success] = t:wellcome
      redirect_to @user
    else
      render :new
    end
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private
    def user_params
      params.require(:user).permit :email, :name, :password, :password_confirmation
    end
end
