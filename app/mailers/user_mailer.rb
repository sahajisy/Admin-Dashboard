# app/mailers/user_mailer.rb

class UserMailer < ApplicationMailer
    def password_reset(user)
      @user = user
      mail(to: @user.email, subject: 'Password Reset')
    end
  end
  