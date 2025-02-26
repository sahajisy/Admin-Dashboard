ActiveAdmin.register Score do
  permit_params :exam_id, :applicant_id, :score

  index do
    selectable_column
    id_column
    column :exam
    column :applicant
    column :score
    actions
  end
end
