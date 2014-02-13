# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Label.first_or_create(value: :best)
Label.first_or_create(value: :helpful)

slido = User.first_or_initialize(login: 'slido')

slido.update_attributes(
  email:   'automaton@sli.do',
  password: SecureRandom.hex,
  first:    'Slido',
  role:     :student
)

slido.save!
