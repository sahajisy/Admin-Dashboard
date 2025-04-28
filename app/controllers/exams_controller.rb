class ExamsController < ApplicationController
  LEVEL_ORDER = { "N5" => 1, "N4" => 2, "N3" => 3, "N2" => 4}
  before_action :set_exam, only: [:show, :submit]
  before_action :authenticate_exam_applicant!, only: [:show, :submit]
  before_action :check_already_taken, only: [:show, :submit]
  before_action :check_exam_eligibility, only: [:show, :submit]
  before_action :check_exam_timing, only: [:show, :submit]
  before_action :check_exam_access, only: [:show]

  def show
    Rails.logger.info "Details Viewed: #{params[:details_viewed]}"
    unless params[:details_viewed]
      redirect_to details_exam_path(@exam) and return
    end
    @applicant = current_exam_applicant
    @end_time = Time.now + @exam.duration.minutes
    @questions = @exam.questions.includes(:options).shuffle
  end

  def submit
    @applicant = current_exam_applicant
    total_score = 0
    (params[:answers] || {}).each do |question_id, option_id|
      correct_option = Option.find_by(question_id: question_id, correct: true)
      total_score += 1 if correct_option && (correct_option.id.to_s == option_id)
      # Create an Answer record for applicant's chosen option
      Answer.create(question_id: question_id, option_id: option_id, applicant_id: @applicant.id)
    end
    Score.create(exam: @exam, applicant: @applicant, score: total_score)

    score_record = Score.create(exam: @exam, applicant: @applicant, score: total_score)

    ExamMailer.send_score(@exam, @applicant, score_record.score).deliver_now

    # Redirect to a thank you page after exam submission (either submitted via button or auto-submitted on timer expiry)
    redirect_to thank_you_exams_path, notice: 'Exam submitted successfully!'
  end

  def thank_you
    # A simple template can display a thank-you message to the applicant.
  end

  def details
    @exam = Exam.find(params[:id]) # Fetch the exam details
  end

  private

  # If an encoded parameter is provided, decode it; otherwise, use normal parameters
  def set_exam
    if params[:encoded].present?
      exam_id, applicant_id = decode_encoded_params(params[:encoded])
      @exam = Exam.find(exam_id)
      # Optionally, if applicant_id is provided via encoded params, store the applicant id in session:
      session[:exam_applicant_id] = applicant_id
    else
      @exam = Exam.find(params[:id])
    end
  end

  # Check if an applicant has “logged in” (i.e. their id is saved in session)
  def authenticate_exam_applicant!
    unless session[:exam_applicant_id].present?
      # Redirect to exam session login (exam_sessions#new) if not logged in,
      # passing along the relevant exam_id.
      redirect_to new_exam_session_path(exam_id: params[:id]), alert: "Please login to take the exam."
    end
  end

  # Return the current applicant using the session variable.
  def current_exam_applicant
    Applicant.find(session[:exam_applicant_id])
  end

  # Generate an encoded string from exam_id and applicant_id using Base64 (simple obfuscation)
  def generate_encoded_params(exam_id, applicant_id)
    raw = "#{exam_id}:#{applicant_id}"
    Base64.urlsafe_encode64(raw)
  end 

  # Decode the encoded parameter back into exam_id and applicant_id
  def decode_encoded_params(encoded)
    decoded = Base64.urlsafe_decode64(encoded)
    decoded.split(":")
  end

  # Check if the applicant has already appeared for the exam
  def check_already_taken
    if Score.exists?(exam: @exam, applicant: current_exam_applicant)
      flash[:alert] = "You have already appeared for this exam."
      redirect_to thank_you_exams_path(@exam, applicant_id: current_exam_applicant.id)
    end
  end  

  # Check if the applicant's JLPT level qualifies for the exam.
  # In this example, we assume an applicant must have a JLPT level
  # equal to or higher (numerically) than @exam.required_jlpt_level.
  def check_exam_eligibility
    required = @exam.required_jlpt_level
    return if required.blank?  # If no requirement is set, allow access

    applicant = current_exam_applicant

    # If the applicant's level (numeric) is not equal to the required level's value,
    # then redirect them.
    if LEVEL_ORDER[applicant.jlpt_level] != LEVEL_ORDER[required]
      Rails.logger.info "Applicant's Level: #{current_exam_applicant.jlpt_level}"
      Rails.logger.info "Required Level for exam: #{@exam.required_jlpt_level}"
      flash[:alert] = "You are not eligible for this exam. This exam is designed for applicants with level #{required}."
      redirect_to wrong_exam_exams_path(@exam, applicant_id: current_exam_applicant.id)
    end
  end

  def check_exam_timing
    # Convert current time to IST
    current_time_ist = Time.current.in_time_zone('Asia/Kolkata')
    start_time_ist = @exam.start_time.in_time_zone('Asia/Kolkata')
    end_time_ist = @exam.end_time.in_time_zone('Asia/Kolkata')

    if current_time_ist < start_time_ist
      flash[:alert] = "The exam has not started yet. It will begin at #{start_time_ist.strftime("%I:%M %p IST")}."
      #redirect_to new_exam_session_path(exam_id: params[:id]) and return
    elsif current_time_ist > end_time_ist
      flash[:alert] = "The exam ended at #{end_time_ist.strftime("%I:%M %p IST")}. You cannot take the exam now."
      #redirect_to new_exam_session_path(exam_id: params[:id]) and return
    end  
  end

  def check_exam_access
    exam_session_key = "exam_#{params[:id]}_applicant_#{params[:applicant_id]}"
    
    if session[exam_session_key].present?
      flash[:alert] = "You have already started or completed this exam."
      #redirect_to new_exam_session_path(exam_id: params[:id])
      return
    end

    # Mark exam as started with IST time
    session[exam_session_key] = Time.current.in_time_zone('Asia/Kolkata')
  end
end