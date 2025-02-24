class ContactMailer < ApplicationMailer
  default to: "info@napoleonnews.com"  # Change to your actual support email

  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message

    mail(from: 'postmaster@napoleonnews.com', to: 'nnagencyinfo@gmail.com', subject: "New Contact Form Submission from #{@name}")
  end
end