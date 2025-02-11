class UserMailer < ApplicationMailer
  def welcome_email(user)
    mail(
      from: 'no-reply@napoleonnews.com',
      to: user.email,
      subject: 'Welcome to Our Platform',
      body: 'Thanks for signing up!'
    )
  end
end
