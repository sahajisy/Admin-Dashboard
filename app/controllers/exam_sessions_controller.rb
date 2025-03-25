class ExamSessionsController < ApplicationController
  # GET /exam_sessions/new?exam_id=1
  def new
    @exam = Exam.find(params[:exam_id])
    # Render a form that submits email only.
  end

  # POST /exam_sessions
  def create
    @exam = Exam.find(params[:exam_id])
    email = params[:email].to_s.downcase.strip
    @applicant = Applicant.find_by(mail_id: email)

    unless @applicant
      flash.now[:alert] = "Email not found. Please try again."
      render :new and return
    end

    if params[:otp].present?
      # OTP submitted; validate it.
      if params[:otp] == session[:generated_otp]
        # OTP is correct; log in the applicant.
        session[:exam_applicant_id] = @applicant.id
        session.delete(:generated_otp)  # clear it after use
        redirect_to exam_path(@exam, applicant_id: @applicant.id), notice: "OTP verified! Good luck with the exam."
      else
        flash.now[:alert] = "Invalid OTP. Please try again."
        render :otp and return
      end
    else
      # No OTP has been submitted yet. Generate OTP, send email, and render OTP form.
      generated_otp = rand(100000..999999).to_s  # generates a 6-digit code as string
      session[:generated_otp] = generated_otp

      # Send the OTP by email
      ExamMailer.send_otp(@exam, @applicant, generated_otp).deliver_now

      flash.now[:notice] = "An OTP has been sent to your email. Please enter it below to continue."
      render :otp  # render an OTP form view
    end
  end

  # Optional: Log out action to clear session
  def destroy
    session.delete(:exam_applicant_id)
    redirect_to root_path, notice: "Logged out."
  end
end
