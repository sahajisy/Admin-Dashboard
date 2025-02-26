ActiveAdmin.register Answer do
  permit_params :content, :correct, :question_id

  form do |f|
    f.inputs "Answer Details" do
      f.input :question
      f.input :content
      f.input :correct
    end
    f.actions
  end
end
