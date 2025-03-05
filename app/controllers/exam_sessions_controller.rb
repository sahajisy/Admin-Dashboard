class ExamSessionsController < ApplicationController
  def new
    # Here, we expect the exam_id to be passed in the URL.
    @exam = Exam.find(params[:exam_id])
    # Do not try to load an applicant; they will enter their email.
  end

  def create
    @exam = Exam.find(params[:exam_id])
    # Find the applicant by email instead of by applicant_id.
    @applicant = Applicant.find_by(mail_id: params[:email].downcase.strip)
    if @applicant.present?
      # Log the applicant in by setting their id in session.
      session[:exam_applicant_id] = @applicant.id
      # Redirect to the exam page with the exam_id and applicant_id as parameters.
      redirect_to exam_path(@exam, applicant_id: @applicant.id)
    else
      flash.now[:alert] = "Email not found. Please check your email address."
      render :new
    end
  end

  def destroy
    session.delete(:exam_applicant_id)
    redirect_to root_path, notice: "You have been logged out."
  end
end
