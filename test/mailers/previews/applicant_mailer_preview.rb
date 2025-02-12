# Preview all emails at http://localhost:3000/rails/mailers/applicant_mailer
class ApplicantMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/applicant_mailer/payment_updated
  def payment_updated
    ApplicantMailer.payment_updated
  end

end
