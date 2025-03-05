ActiveAdmin.register Option do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :content, :correct, :question_id, :created_by, :updated_by
  #
  # or
  #
  # permit_params do
  #   permitted = [:content, :correct, :question_id, :created_by, :updated_by]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
