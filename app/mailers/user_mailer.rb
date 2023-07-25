# app/mailers/user_mailer.rb

class UserMailer < ApplicationMailer
  def ticket_email
    @purchase = params[:purchase]
    @pdf_file = params[:pdf_file]

    attachments['ticket.pdf'] = File.read(@pdf_file)
    mail(to: @purchase.customer.user.email, subject: 'Your Ticket Purchase Confirmation')
  end
end
  