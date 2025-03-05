ActiveAdmin.register Exam do
  permit_params :title, :description, :duration,
                questions_attributes: [:id, :content, :_destroy, options_attributes: [:id, :content, :correct, :_destroy]]

  form do |f|
    f.inputs 'Exam Details' do
      f.input :title
      f.input :description
      f.input :duration, label: 'Duration (minutes)'
    end

    f.has_many :questions, allow_destroy: true, new_record: true do |q|
      q.input :content
      q.has_many :options, allow_destroy: true, new_record: true do |o|
        o.input :content
        o.input :correct, hint: "Check if this is the correct answer"
      end
    end

    f.actions
  end

  # Action to send Exam Link to an applicant. For demonstration, we simply use the first applicant.
  member_action :send_exam_link, method: :post do
    # In a real app, you would let the admin choose an applicant.
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
