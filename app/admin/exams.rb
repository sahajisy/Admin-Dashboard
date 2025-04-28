ActiveAdmin.register Exam do
  permit_params :title, :description, :duration, :required_jlpt_level, :start_time, :end_time,
                exam_questions_attributes: [:id, :question_id, :order, :_destroy] # Permit nested attributes for exam_questions

  remove_filter :required_jlpt_level

  # Add a custom filter for exam_questions
  filter :exam_questions_question_id, as: :select, collection: -> { Question.all.map { |q| [q.content, q.id] } }, label: "Questions"

  form do |f|
    f.inputs "Exam Details" do
      f.input :title
      f.input :description
      f.input :duration, label: "Duration (minutes)"
      f.input :required_jlpt_level, as: :select, collection: ['N5', 'N4', 'N3', 'N2']
      f.input :start_time, as: :date_time_picker
      f.input :end_time, as: :date_time_picker
    end

    f.inputs "Select Pre-Created Questions" do
      f.has_many :exam_questions, allow_destroy: true, new_record: true do |eq|
        eq.inputs class: "inline-fields" do
          eq.input :question_id,
                   as: :select,
                   collection: Question.all.map { |q| [q.content, q.id] },
                   label: "Question"
          eq.input :order,
                   as: :number,
                   label: "Order"
        end
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :duration
    end

    panel "Questions" do
      table_for exam.exam_questions.order(:order) do
        column("Order") { |eq| eq.order }
        column("Question") { |eq| eq.question.content }
        column("Category") { |eq| eq.question.category }
      end
    end
  end

  # Action to send Exam Link to an applicant. For demonstration, we simply use the first applicant.
  member_action :send_exam_link, method: :post do
    applicant = Applicant.find(params[:applicant_id])
    ExamMailer.send_exam_link(resource, applicant).deliver_now
    redirect_to resource_path, notice: "Exam link sent to #{applicant.mail_id}."
  end

  action_item :send_exam_link, only: :show do
    if Applicant.any?
      # For demonstration, we use the first applicant.
      link_to 'Send Exam Link', send_exam_link_admin_exam_path(resource, applicant_id: Applicant.first.id), method: :post 
    end
  end

  controller do
    def destroy
      @exam = Exam.find(params[:id])
      if @exam.questions.any?
        flash[:error] = "This exam has associated questions. Please delete the questions first or reassign them to another exam."
        redirect_to admin_exam_path(@exam)
      else
        if @exam.destroy
          flash[:notice] = "Exam was successfully deleted."
          redirect_to admin_exams_path
        else
          flash[:error] = "Failed to delete exam."
          redirect_to admin_exam_path(@exam)
        end
      end
    end
  end
end
