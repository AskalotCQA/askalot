# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Shared::Role.find_or_create_by! name: :student
Shared::Role.find_or_create_by! name: :teacher
Shared::Role.find_or_create_by! name: :administrator

Shared::Label.find_or_create_by! value: :best
Shared::Label.find_or_create_by! value: :helpful

slido = Shared::User.find_or_initialize_by(login: 'slido')

slido.update_attributes(
  email: 'automaton@sli.do',
  password: SecureRandom.hex,
  first: 'Automaton',
  last: 'Slido',
  about: 'Automatizovaný robot, ktorý zbiera otázky zo systému [sli.do](http://sli.do)',
  show_email: false,
  role: :student
)

slido.save!

unless Shared::QuestionType.find_by mode: :question
  type = Shared::QuestionType.create mode: :question, name: 'Question', icon: 'fa-question'

  Shared::Question.where(question_type_id: nil, document_id: nil).update_all question_type_id: type.id

  puts "Question type 'question' created"
end

unless Shared::QuestionType.find_by mode: :document
  type = Shared::QuestionType.create mode: :document, name: 'Document question', icon: 'fa-file-o'

  Shared::Question.where(question_type_id: nil).where('document_id IS NOT NULL').update_all question_type_id: type.id

  puts "Question type 'document' created"
end

unless Shared::QuestionType.find_by mode: :forum
  Shared::QuestionType.create mode: :forum, name: 'Discussion', icon: 'fa-comments-o'

  puts "Question type 'forum' created"
end