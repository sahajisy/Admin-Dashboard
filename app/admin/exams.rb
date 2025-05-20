ActiveAdmin.register Exam do
  config.per_page = 20 # or any number you prefer

  permit_params :title, :description, :duration, :required_jlpt_level, :start_time, :end_time,
                exam_questions_attributes: [:id, :question_id, :order, :_destroy] # Permit nested attributes for exam_questions

  remove_filter :required_jlpt_level

  # Add a custom filter for exam_questions
  filter :exam_questions_question_id, as: :select, collection: -> { Question.all.map { |q| [q.content, q.id] } }, label: "Questions"

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :duration
    column :created_by
    column :updated_by
    column :created_at
    column :updated_at
    column :required_jlpt_level
    column("Start Time") { |exam| exam.start_time.in_time_zone('Asia/Kolkata').strftime("%B %d, %Y %H:%M") }
    column("End Time") { |exam| exam.end_time.in_time_zone('Asia/Kolkata').strftime("%B %d, %Y %H:%M") }
    actions
  end

  form do |f|
    f.inputs "Exam Details" do
      f.input :title
      f.input :description
      f.input :duration, label: "Duration (minutes)"
      f.input :required_jlpt_level, as: :select, collection: ['N5', 'N4', 'N3', 'N2']
      f.input :start_time, as: :date_time_picker
      f.input :end_time, as: :date_time_picker
    end

    # Render the simple form partial for exam questions
    render partial: 'admin/exams/exam_questions_fields', locals: { f: f }


    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :duration
      row("Start Time") { |exam| exam.start_time.in_time_zone('Asia/Kolkata').strftime("%d-%m-%Y %I:%M %p %Z") }
      row("End Time") { |exam| exam.end_time.in_time_zone('Asia/Kolkata').strftime("%d-%m-%Y %I:%M %p %Z") }
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
