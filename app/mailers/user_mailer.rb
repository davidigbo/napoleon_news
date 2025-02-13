class UserMailer < ApplicationMailer
  layout 'mailer'

  def welcome_email(user)
    @user = user
    attachments.inline['icon.png'] = File.read(Rails.root.join('public', 'icon.png'))
    mail(
      from: 'no-reply@napoleonnews.com',
      to: @user.email,
      subject: 'Welcome to Our Platform',
    )
  end
end
