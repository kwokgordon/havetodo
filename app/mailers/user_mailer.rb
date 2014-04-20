class UserMailer < ActionMailer::Base
  default from: "havetodoapp@gmail.com"
  
  def invite_friend(user, friend_email)
    @user = user
    if Rails.env.development?
      @url = "http://184.64.50.5:3000/users/sign_up"
    elsif Rails.env.production?
      @url = "http://fathomless-island-6793.herokuapp.com/users/sign_up"
    else
      @url = ""
    end
    
    mail(to: friend_email, subject: "Someone invited you to HaveTodo!")
  end
end
