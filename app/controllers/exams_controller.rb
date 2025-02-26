class ExamsController < ApplicationController
  def index
    @exams = Exam.all
  end

  def show
    @exam = Exam.find(params[:id])
    @applicant = Applicant.find(params[:id])
    @end_time = Time.now + @exam.duration.minutes
    @questions = @exam.questions.includes(:answers).shuffle
  end

  def submit
    @exam = Exam.find(params[:id])
    @applicant = Applicant.find(params[:applicant_id])
    @score = 0
    params[:answers].each do |question_id, answer_id|
      if Answer.find(answer_id).correct
        @score += 1
      end
    end
    Score.create(exam: @exam, applicant: @applicant, score: @score)
  end
end
