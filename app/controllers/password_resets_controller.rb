class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase!
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t :reset_instructions
      redirect_to root_url
    else
      flash.now[:danger] = t :email_not_found
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(:cant_empty))
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t :password_has_been
      redirect_to @user
    else
      render :edit
    end
  end
  
  def edit
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = t :pass_reset
        redirect_to new_password_reset_url
      end
    end
end