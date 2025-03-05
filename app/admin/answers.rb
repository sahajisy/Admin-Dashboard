ActiveAdmin.register Answer do
  permit_params :question_id, :option_id, :applicant_id

  index do
    selectable_column
    id_column
    column "Question" do |answer|
      answer.question.try(:content) || "N/A"
    end
    column "Option Chosen" do |answer|
      answer.option.try(:content) || "N/A"
    end
    column "Applicant" do |answer|
      answer.applicant.try(:name) || "N/A"
    end
    actions
  end

  show do
    attributes_table do
      row "ID" do |answer|
        answer.id
      end
      row "Question" do |answer|
        answer.question.try(:content) || "N/A"
      end
      row "Option Chosen" do |answer|
        answer.option.try(:content) || "N/A"
      end
      row "Applicant" do |answer|
        answer.applicant.try(:name) || "N/A"
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Answer Details" do
      f.input :question, as: :select, collection: Question.all.map { |q| [q.content, q.id] }
      f.input :option, as: :select, collection: Option.all.map { |o| [o.content, o.id] }
      f.input :applicant, as: :select, collection: Applicant.all.map { |a| [a.mail_id, a.id] }
    end
    f.actions
  end
end
