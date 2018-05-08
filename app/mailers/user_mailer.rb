class UserMailer < ApplicationMailer

  def account_activation user
    @user = user
    mail to: user.email, subject: (t :account_activated)
  end

  def password_reset user
    @user = user
    
    mail to: user.email, subject: (t :pass_reset)
  end
end
