class ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :submit]
  before_action :authenticate_exam_applicant!, only: [:show, :submit]
  before_action :check_already_taken, only: [:show, :submit]


  def show
    @applicant = current_exam_applicant
    @end_time = Time.now + @exam.duration.minutes  # Set timer end time
    @questions = @exam.questions.includes(:options).shuffle  # Shuffle questions (options will be shuffled in the view)
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

    # Redirect to a thank you page after exam submission (either submitted via button or auto-submitted on timer expiry)
    redirect_to thank_you_exams_path, notice: 'Exam submitted successfully!'
  end

  def thank_you
    # A simple template can display a thank-you message to the applicant.
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
end