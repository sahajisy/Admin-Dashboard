ActiveAdmin.register Question do
  menu false
  permit_params :content, :exam_id, :category, :image, :audio,
                options_attributes: [:id, :content, :correct, :_destroy]

  remove_filter :image_attachment, :image_blob, :audio_attachment, :audio_blob

  form html: { multipart: true } do |f|
    f.inputs "Question Details" do
      f.input :exam, as: :select, collection: Exam.all.pluck(:title, :id)
      f.input :content
      f.input :category, as: :select, collection: ["Vocabulary", "Grammar", "Reading", "Listening"], prompt: "Select Category"
      f.input :image, as: :file, hint: f.object.image.attached? ? 
              image_tag(url_for(f.object.image), height: 100) : "No image attached"
      f.input :audio, as: :file, hint: f.object.audio.attached? ?
              audio_tag(url_for(f.object.audio), controls: true) : "No audio attached"
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

  member_action :preview, method: :get do
    question = Question.find(params[:id])
    render partial: 'admin/questions/preview', locals: { question: question }
  end
end
