class ExamMailer < ApplicationMailer
    def send_exam_link(exam, applicant)
      @exam = exam
      @applicant = applicant
      @exam_url = exam_url(@exam, applicant_id: @applicant.id)
      mail(to: @applicant.mail_id, subject: 'Your Exam Link')
    end
  end
  