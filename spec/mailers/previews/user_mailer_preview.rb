# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def ticket_email
    purchase = Purchase.first # or any purchase object you want to use for the preview
    UserMailer.with(purchase: purchase).ticket_email
  end
end
