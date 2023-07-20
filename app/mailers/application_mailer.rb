# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "from@ticketstar.com"
  layout "mailer"
end
