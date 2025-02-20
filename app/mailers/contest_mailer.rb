class ContestMailer < ApplicationMailer
  layout 'mailer'

  def new_contestant_mail(user)
    @user = user
    attachments.inline['icon.png'] = File.read(Rails.root.join('public', 'icon.png'))
    mail(
      from: 'no-reply@napoleonnews.com',
      to: user.email,
      subject: 'Welcome to the contest.',
    )
  end

  def approve_contestant_mail(user)
    @user = user
    attachments.inline['icon.png'] = File.read(Rails.root.join('public', 'icon.png'))
    mail(
      from: 'no-reply@napoleonnews.com',
      to: user.email,
      subject: 'Congratulations! Your submission is approved.',
    )
  end

  def reject_contestant_mail(user)
    @user = user
    attachments.inline['icon.png'] = File.read(Rails.root.join('public', 'icon.png'))
    mail(
      from: 'no-reply@napoleonnews.com',
      to: user.email,
      subject: 'Your contest submission status',
    )
  end
end
