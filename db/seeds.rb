# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

slido = User.find_or_initialize_by(login: 'slido')

slido.update_attributes(
<<<<<<< HEAD
  email:   'automaton@sli.do',
=======
  email:   'slido@sli.do',
>>>>>>> Add slido attributes
  password: SecureRandom.hex,
  first:    'Slido',
  role:     :student
)
