# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

root = Shared::Category.find_or_create_by! name: :root, uuid: :root_uuid, full_tree_name: :Root
year = Shared::Category.find_or_create_by! name: Shared::Tag.current_academic_year_value, parent_id: root.id

if Rails.env_type.test?
  grade = Shared::Category.find_or_create_by! name: 'Grade', parent_id: year.id
  subject = Shared::Category.find_or_create_by! name: 'Subject', parent_id: grade.id
  part    = Shared::Category.find_or_create_by! name: 'Part', parent_id: subject.id
end
