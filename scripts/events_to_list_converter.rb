
events = Shared::Event.all

not_identified = 0
events.each do |event|
  json_data = event.data
  params = event.data[:params]
  if json_data[:action] == 'mooc/units.show' && params[:resource_link_id] && params[:user_id]
      user = Shared::User.find_by(login: params[:user_id])
      category = Shared::Category.find_by(lti_id: params[:resource_link_id].split('-', 2).last)
    if user and category
      Shared::List.create(category_id: category.id,
                          lister_id: user.id,
                          unit_view: TRUE)
    else
      not_identified += 1
    end
  end
end

puts "Not identified: #{not_identified}"