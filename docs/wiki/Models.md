# Models Documentation

## Applicant
Represents a student applicant in the system.

### Attributes
- `name`: string
- `category`: string
- `location`: string
- `programme`: string
- `college`: string
- `branch`: string
- `graduation_year`: integer
- `batch`: string
- `whatsapp_number`: string
- `inheritance`: string
- `a2j_id`: string
- `mail_id`: string
- `jlpt_level`: string

### Associations
- has_many :payment_histories
- has_many :exams
- has_many :scores

## Exam
Represents an examination in the system.

### Attributes
- `title`: string
- `description`: text
- `start_time`: datetime
- `end_time`: datetime
- `required_jlpt_level`: string

### Associations
- has_many :questions
- has_many :scores