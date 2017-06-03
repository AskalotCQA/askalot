# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Shared::Role.find_or_create_by! name: :teacher_assistant

slido = Shared::User.find_by login: :slido

Shared::ContextUser.create user: slido, context_id: 1

course   = Shared::Category.find_or_create_by! name: :course, uuid: :course_uuid, askalot_page_url: :page_url if Rails.env_type.test?
category = Shared::Category.find_or_create_by! name: :section, uuid: :section_uuid, parent_id: course.id if Rails.env_type.test?

if Rails.env_type.test?
  unit    = Shared::Category.find_or_create_by! name: 'Unit', parent_id: category.id

  # we have the same category depths configuration for both test envs so this category must be created
  subunit = Shared::Category.find_or_create_by! name: 'SubUnit', parent_id: unit.id
end
