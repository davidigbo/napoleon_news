class ContactsController < ApplicationController
  def create
    ContactMailer.contact_email(params[:name], params[:email], params[:message]).deliver_now
    redirect_to request.referer, notice: "Your message has been sent successfully!"
  end
end