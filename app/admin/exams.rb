ActiveAdmin.register Exam do
  permit_params :title, :description, :duration,:required_jlpt_level,
                questions_attributes: [:id, :content, :_destroy, options_attributes: [:id, :content, :correct, :_destroy]]
                remove_filter :required_jlpt_level


  form do |f|
    f.inputs "Exam Details" do
      f.input :title
      f.input :description
      f.input :duration, label: "Duration (minutes)"
      f.input :required_jlpt_level, as: :select, collection: ['N5', 'N4', 'N3', 'N2']
    end

    f.inputs "Select Pre-Created Questions" do
      f.input :question_ids, 
              as: :select, 
              collection: Question.all.map { |q| ["#{q.content} (#{q.category})", q.id] },
              input_html: { multiple: true },
              label: "Choose Questions"
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
      table_for exam.questions do
        column("Question") { |question| question.content }
        column("Category") { |question| question.category }
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
end
