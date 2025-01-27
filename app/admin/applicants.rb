ActiveAdmin.register Applicant do
  permit_params :serial_no, :category, :location, :programme, :college, :branch, :graduation_year, :name, :batch, :whatsapp_number, :inheritance, :a2j_id, :mail_id, :jlpt_level, :whatsapp, :amount, :balance, :admission_date, :admission_done_by, :balance_reminder, :recipt_no, :payment_mode, :remarks, payment_histories_attributes: [:jlpt_level, :payable_amount, :paid_amount, :payment_date, :updated_by, :_destroy, :applicant_id]

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

    def update
      @applicant = Applicant.find(params[:id])
      @applicant.admission_done_by = current_user.username
      if @applicant.update(permitted_params[:applicant])
        redirect_to admin_applicant_path(@applicant), notice: 'Applicant was successfully updated.'
      else
        render :edit
      end
    end
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
      f.input :batch, as: :select, collection: ["Takao", "Mitake", "Tanigawa","Daisen","Hakusan","Tateyama","Fujisan"]
      f.input :whatsapp_number
      f.input :inheritance, as: :select, collection: ["Inhert", "New", "Repeater"]
      f.input :a2j_id
      f.input :mail_id
      f.input :jlpt_level, as: :select, collection: ['N5', 'N4', 'N3', 'N2']
      f.input :whatsapp, as: :select, collection: ["Yes", "No"]
      f.input :amount
      f.input :balance, input_html: { id: 'balance_input' }
      f.input :admission_date, as: :datepicker
      f.input :balance_reminder, as: :select, collection: ["Yes-Reminder 1", "Yes-Reminder 2", "Yes-Reminder 3","Removed","No"]
      f.input :recipt_no
      f.input :payment_mode, as: :select, collection: ["UPI QR", "NEFT", "Cash", "Cheque"]
      f.input :remarks
    end

    f.has_many :payment_histories, allow_destroy: true, new_record: true do |pf|
      pf.input :payable_amount
      pf.input :paid_amount
      pf.input :payment_date, as: :datepicker
      pf.input :updated_by
    end

    f.actions
  end

  controller do
    def new
      @applicant = Applicant.new
      @applicant.payment_histories.build
    end

    def edit
      @applicant = Applicant.find(params[:id])
      @applicant.payment_histories.build if @applicant.payment_histories.empty?
    end
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
      row :balance
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
  end
end
