# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_04_09_145717) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "applicant_id", null: false
    t.bigint "question_id", null: false
    t.bigint "option_id", null: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_answers_on_applicant_id"
    t.index ["option_id"], name: "index_answers_on_option_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "applicants", force: :cascade do |t|
    t.integer "serial_no"
    t.string "category"
    t.string "location"
    t.string "programme"
    t.string "college"
    t.string "branch"
    t.string "graduation_year"
    t.string "name"
    t.string "batch"
    t.string "whatsapp_number"
    t.string "inheritance"
    t.string "a2j_id"
    t.string "mail_id"
    t.string "jlpt_level"
    t.string "whatsapp"
    t.decimal "amount"
    t.decimal "balance"
    t.date "admission_date"
    t.string "admission_done_by"
    t.string "balance_reminder"
    t.string "recipt_no"
    t.string "payment_mode"
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exam_questions", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "question_id", null: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_exam_questions_on_exam_id"
    t.index ["question_id"], name: "index_exam_questions_on_question_id"
  end

  create_table "exams", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "duration"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "required_jlpt_level"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "exams_questions", id: false, force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "question_id", null: false
    t.index ["exam_id", "question_id"], name: "index_exams_questions_on_exam_id_and_question_id"
    t.index ["question_id", "exam_id"], name: "index_exams_questions_on_question_id_and_exam_id"
  end

  create_table "options", force: :cascade do |t|
    t.string "content"
    t.boolean "correct"
    t.bigint "question_id", null: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "payment_histories", force: :cascade do |t|
    t.string "jlpt_level"
    t.decimal "payable_amount"
    t.decimal "paid_amount"
    t.date "payment_date"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "applicant_id", null: false
    t.index ["applicant_id"], name: "index_payment_histories_on_applicant_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "content"
    t.bigint "exam_id", null: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "jlpt_level"
    t.index ["exam_id"], name: "index_questions_on_exam_id"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "applicant_id", null: false
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_scores_on_applicant_id"
    t.index ["exam_id"], name: "index_scores_on_exam_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "applicants"
  add_foreign_key "answers", "options"
  add_foreign_key "answers", "questions"
  add_foreign_key "exam_questions", "exams"
  add_foreign_key "exam_questions", "questions"
  add_foreign_key "options", "questions"
  add_foreign_key "payment_histories", "applicants"
  add_foreign_key "questions", "exams"
  add_foreign_key "scores", "applicants"
  add_foreign_key "scores", "exams"
end
