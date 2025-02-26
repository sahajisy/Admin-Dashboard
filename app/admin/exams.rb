ActiveAdmin.register Exam do
  permit_params :title, :description, :duration, question_ids: [], questions_attributes: [:id, :content, :_destroy, answers_attributes: [:id, :content, :correct, :_destroy]]

  form do |f|
    f.inputs "Exam Details" do
      f.input :title
      f.input :description
      f.input :duration, label: "Duration (in minutes)"
    end
    f.has_many :questions, allow_destroy: true, new_record: true do |q|
      q.input :content
      q.has_many :answers, allow_destroy: true, new_record: true do |a|
        a.input :content
        a.input :correct
      end
    end
    f.actions
  end

  member_action :send_exam_link, method: :post do
    applicant = Applicant.find(params[:id])
    ExamMailer.send_exam_link(resource, applicant).deliver_now
    redirect_to resource_path, notice: "Exam link sent to #{applicant.email}."
  end

  action_item :send_exam_link, only: :show do
    link_to "Send Exam Link", send_exam_link_admin_exam_path(resource), method: :post
  end
end
