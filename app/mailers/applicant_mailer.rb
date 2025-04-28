class ApplicantMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.applicant_mailer.payment_updated.subject
  #
  def payment_updated(applicant, payment_history)
    @applicant = applicant
    @payment_history = payment_history

    if @applicant.mail_id.present?
      mail(to: @applicant.mail_id, subject: 'Thank you for your payment.')
    else
      Rails.logger.error "Applicant mail_id is missing or invalid for applicant: #{@applicant.id}"
    end
  end
end
