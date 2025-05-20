ActiveAdmin.register Score do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :exam_id, :applicant_id, :score
  #
  # or
  #
  actions :index, :show
  
  permit_params do
     permitted = [:exam_id, :applicant_id, :score]
     permitted << :other if params[:action] == 'create' && current_user.admin?
     permitted
   end
  
end
