ActiveAdmin.register Question do
  permit_params :content, exam_ids: [], answers_attributes: [:id, :content, :correct, :_destroy]

  form do |f|
    f.inputs "Question Details" do
      f.input :exams
      f.input :content
    end
    f.has_many :answers, allow_destroy: true, new_record: true do |a|
      a.input :content
      a.input :correct
    end
    f.actions
  end
end
