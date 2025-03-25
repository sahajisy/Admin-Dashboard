class ExamMailer < ApplicationMailer
    def send_exam_link(exam, applicant)
      @exam = exam
      @applicant = applicant
      @exam_url = exam_url(@exam, applicant_id: @applicant.id)
      mail(to: @applicant.mail_id, subject: 'Your Exam Link')
    end
    def send_otp(exam, applicant, otp)
      @exam = exam
      @applicant = applicant
      @otp = otp
      @exam_url = exam_url(@exam, applicant_id: @applicant.id)  # this URL will be used after OTP verification
  
      mail(to: @applicant.mail_id, subject: "Your OTP for #{@exam.title} Exam")
    end
  end
  