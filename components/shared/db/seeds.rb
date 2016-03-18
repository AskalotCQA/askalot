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

root = Shared::Category.find_or_create_by! name: :root, uuid: :root_uuid if Rails.module.university? || Rails.env_type.test?

Shared::Category.find_or_create_by! name: Shared::Tag.current_academic_year_value, parent_id: root.id if Rails.module.university? || Rails.env_type.test?

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

Shared::ContextUser.create user: slido, context_id: 1 if Rails.module.mooc?
