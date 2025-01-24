ActiveAdmin.register User do
  permit_params :username, :email, :password, :password_confirmation, :role

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :role
    actions
  end

  #filter :username
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  #filter :role

  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role, as: :select, collection: ["Admin", "Editor", "Viewer"]
    end
    f.actions
  end
  action_item :send_password_reset, only: :show do
    link_to 'Send Password Reset', send_password_reset_admin_user_path(user), method: :post
  end

  member_action :send_password_reset, method: :post do
    user = User.find(params[:id])
    UserMailer.password_reset(user).deliver_now
    redirect_to admin_user_path(user), notice: "Password reset email sent."
  end

end
