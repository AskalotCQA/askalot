# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

University::Role.find_or_create_by! name: :student
University::Role.find_or_create_by! name: :teacher
University::Role.find_or_create_by! name: :administrator

University::Label.find_or_create_by! value: :best
University::Label.find_or_create_by! value: :helpful

slido = University::User.find_or_initialize_by(login: 'slido')

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
