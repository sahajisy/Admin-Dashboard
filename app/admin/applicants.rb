ActiveAdmin.register Applicant do
  permit_params :serial_no, :category, :location, :programme, :college, :branch, :graduation_year, :name, :batch, :whatsapp_number, :inheritance, :a2j_id, :mail_id, :jlpt_level, :whatsapp, :amount, :balance, :admission_date, :admission_done_by, :balance_reminder, :recipt_no, :payment_mode, :remarks, 
                payment_histories_attributes: [:jlpt_level, :payable_amount, :paid_amount, :payment_date, :updated_by, :_destroy, :applicant_id]

  remove_filter :exams
  remove_filter :scores
  remove_filter :answers

  controller do
    def create
      @applicant = Applicant.new(permitted_params[:applicant])
      @applicant.admission_done_by = current_user.username
      if @applicant.save
        redirect_to admin_applicant_path(@applicant), notice: 'Applicant was successfully created.'
      else
        render :new
      end
    end

    def payment_histories_params
      params[:applicant][:payment_histories_attributes] || []
    end

    def update
      @applicant = Applicant.find(params[:id])
      @applicant.admission_done_by = current_user.username

      payment_histories_params = params[:applicant][:payment_histories_attributes] || []
      payment_histories_params.each do |index, attributes|
        if attributes[:id].blank?
          @applicant.payment_histories.build(attributes.permit(:payable_amount, :paid_amount, :payment_date, :updated_by).merge(updated_by: current_user.username))
        else
          payment_history = @applicant.payment_histories.find(attributes[:id])
          payment_history.update(attributes.permit(:payable_amount, :paid_amount, :payment_date, :updated_by).merge(updated_by: current_user.username)) unless payment_history.nil?
        end
      end

      if @applicant.update(permitted_params[:applicant].except(:payment_histories_attributes))
        redirect_to admin_applicant_path(@applicant), notice: 'Applicant was successfully updated.'
      else
        render :edit
      end
    end

    def new
      @applicant = Applicant.new
      @applicant.payment_histories.build
    end

    def edit
      @applicant = Applicant.find(params[:id])
      @applicant.payment_histories.build if @applicant.payment_histories.empty?
    end
  end

  index do
    selectable_column
    id_column
    column :category
    column :location
    column :programme
    column :college
    column :branch
    column :graduation_year
    column :name
    column :batch
    column :whatsapp_number
    column :inheritance
    column :a2j_id
    column :mail_id
    column :jlpt_level
    column :whatsapp
    column :amount
    column :balance do |applicant|
      applicant.latest_balance
    end
    column :admission_date
    column :admission_done_by
    column :balance_reminder
    column :recipt_no
    column :payment_mode
    column :remarks
    column 'Scores' do |applicant|
      applicant.scores.map { |s| "Exam: #{s.exam.title} -> #{s.score}" }.join("<br>").html_safe
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :category, as: :select, collection: ["Student", "Working Professional"]
      f.input :location, as: :select, collection: ["Local", "Non Local"]
      f.input :programme, as: :select, collection: ["Regular", "FO"]
      f.input :college
      f.input :branch
      f.input :graduation_year
      f.input :name
      f.input :batch, as: :select, collection: ["Takao", "Mitake", "Tanigawa", "Daisen", "Hakusan", "Tateyama", "Fujisan"]
      f.input :whatsapp_number
      f.input :inheritance, as: :select, collection: ["Inhert", "New", "Repeater"]
      f.input :a2j_id
      f.input :mail_id
      f.input :jlpt_level, as: :select, collection: ['N5', 'N4', 'N3', 'N2']
      f.input :whatsapp, as: :select, collection: ["Yes", "No"]
      f.input :admission_date, as: :datepicker
      f.input :balance_reminder, as: :select, collection: ["Yes-Reminder 1", "Yes-Reminder 2", "Yes-Reminder 3", "Removed", "No"]
      f.input :recipt_no
      f.input :payment_mode, as: :select, collection: ["UPI QR", "NEFT", "Cash", "Cheque"]
      f.input :remarks
    end

    if f.object.new_record?
      f.has_many :payment_histories, allow_destroy: true, new_record: true do |pf|
        pf.input :payable_amount
        pf.input :paid_amount
        pf.input :payment_date, as: :datepicker
      end
    else
      f.has_many :payment_histories, allow_destroy: true, new_record: true do |pf|
        pf.input :paid_amount
        pf.input :payment_date, as: :datepicker
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :category
      row :location
      row :programme
      row :college
      row :branch
      row :graduation_year
      row :name
      row :batch
      row :whatsapp_number
      row :inheritance
      row :a2j_id
      row :mail_id
      row :jlpt_level
      row :whatsapp
      row :amount
      row :balance do |applicant|
        applicant.latest_balance
      end
      row :admission_date
      row :admission_done_by
      row :balance_reminder
      row :recipt_no
      row :payment_mode
      row :remarks
    end

    panel "Payment Histories" do
      table_for applicant.payment_histories do
        column :payable_amount
        column :paid_amount
        column :balance do |history|
          history.balance
        end
        column :payment_date
        column :updated_by
      end
    end

    panel "Answers Panel" do
      if applicant.answers.any?
        # Group answers by exam
        applicant.answers.includes(:question, :option).group_by { |answer| answer.question.exam }.each do |exam, answers|  
          h3 "Exam: #{exam.title}"
          table_for answers do
            column("Question") { |answer| answer.question.content }
            column("Your Answer") { |answer| answer.option.content }
            column("Correct Answer") do |answer|
              correct_option = Option.find_by(question_id: answer.question_id, correct: true)
              correct_option ? correct_option.content : "Not Specified"
            end
            column("Result") do |answer|
              correct_option = Option.find_by(question_id: answer.question_id, correct: true)
              (correct_option && (correct_option.id == answer.option_id)) ? "Correct" : "Wrong"
            end
          end
        end
      else
        h4 "No exam answers available."
      end
    end
  end

  member_action :send_exam_link, method: :post do
    # Choose the exam you want to send. For example, use the first exam.
    exam = Exam.first # or find by title or ID, e.g., Exam.find_by(title: 'Your Exam Name')
    applicant = resource  # 'resource' is the current applicant record
    if exam && applicant
      ExamMailer.send_exam_link(exam, applicant).deliver_now
      redirect_to resource_path, notice: "Exam link sent to #{applicant.mail_id}."
    else
      redirect_to resource_path, alert: "Exam or Applicant not found."
    end
  end

  # Batch action for assigning an exam to the selected applicants
  batch_action :assign_exam, confirm: "Are you sure you want to assign an exam to the selected applicants?" do |ids|
    redirect_to assign_exam_admin_applicants_path(ids: ids.join(','))
  end

  # Custom collection action to render the exam selection form.
  collection_action :assign_exam, method: :get do
    # ids is a comma separated string of applicant ids
    @applicant_ids = params[:ids].split(',')
    @exams = Exam.all
    render 'admin/applicants/assign_exam'  # Ensure you have created this view file.
  end

  # Collection action to process the exam assignment form.
  collection_action :bulk_assign_exam, method: :post do
    applicant_ids = params[:applicant_ids].split(',')
    exam = Exam.find(params[:exam_id])
    applicant_ids.each do |applicant_id|
      applicant = Applicant.find(applicant_id)
      # Send exam link email to this applicant.
      ExamMailer.send_exam_link(exam, applicant).deliver_later
    end
    redirect_to collection_path, notice: "Exam link sent to selected applicants."
  end
end