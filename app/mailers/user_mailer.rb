class UserMailer < ActionMailer::Base
  default from: "havetodoapp@gmail.com"
  
  def invite_friend(user, friend_email)
    @user = user
    
    mail(to: friend_email, subject: "Someone invited you to HaveTodo!")
  end
end
