ActiveAdmin.register Question do
  menu false
  permit_params :content, :exam_id, :category,
                options_attributes: [:id, :content, :correct, :_destroy]

  form do |f|
    f.inputs "Question Details" do
      f.input :exam, as: :select, collection: Exam.all.pluck(:title, :id)
      f.input :content
      f.input :category, as: :select, collection: ["Vocabulary", "Grammar", "Reading"], prompt: "Select Category"
    end

    # Pre-build option records until there are 4 in total.
    (4 - f.object.options.size).times { f.object.options.build } if f.object.options.size < 4

    f.inputs "Options" do
      # The nested form displays each option input field.
      f.has_many :options, 
                 allow_destroy: true, 
                 new_record: true,
                 heading: false,
                 wrapper_html: { class: 'options-container' } do |o|
        o.input :content, 
                label: false, 
                placeholder: "Enter option content",
                wrapper_html: { class: 'option-content' }
        o.input :correct, 
                as: :boolean, 
                label: "Correct?",
                wrapper_html: { class: 'option-correct' }
      end
    end

    f.actions
  end

  index do
    selectable_column
    id_column
    column :content
    column :category
    column "Exam" do |question|
      question.exam.try(:title)
    end
    actions
  end

  show do
    attributes_table do
      row :content
      row :category
      row :exam do |question|
        question.exam.try(:title)
      end
      row "Options" do |question|
        question.options.map do |option|
          "#{option.content} (Correct: #{option.correct})"
        end.join("<br>").html_safe
      end
    end
  end
end
