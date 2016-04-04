module Mooc::HeaderHelper
  def dropdown_tag(clazz, &block)

    output = ''
    output << navbar_dropdown_tag(:'caret-down', nil, '#', class: clazz) do
       capture(&block) if block_given?
       content_tag( :li, link_to(t('administration.navigation'), shared.administration_root_path)) if user_signed_in? && can?(:administrate, :any)
       content_tag( :li, link_to(t('teacher_administration.navigation'), mooc.teacher_administration_root_path)) if user_signed_in? && can?(:teacher_administrate, :any)
       '<li class="divider"></li>'
       content_tag( :li, link_to(t('help.navigation'), shared.help_path))
    end
    output.html_safe
  end

  def header_items()
    output  = ''

    output << navbar_link_tag(t('activity.navigation'), shared.activities_path, class: :'hidden-sm')
    output << navbar_link_tag(t('statistic.navigation'), shared.statistics_path, class: :'hidden-sm') if user_signed_in? && can?(:observe, :any)
    output << navbar_link_tag(t('administration.navigation'), shared.administration_root_path, class: :'hidden-sm hidden md') if user_signed_in? && can?(:administrate, :any)
    output << navbar_link_tag(t('teacher_administration.navigation'), mooc.teacher_administration_root_path, class: :'hidden-sm hidden md') if user_signed_in? && can?(:teacher_administrate, :any)
    output << navbar_link_tag(t('help.navigation'), shared.help_path, class: :'hidden-sm hidden-md')
    output << dropdown_tag('visible-sm') do
      content_tag(:li, link_to(t('activity.navigation'), shared.activities_path))
      content_tag(:li, link_to(t('statistic.navigation'), shared.statistics_path))  if user_signed_in? && can?(:administrate, :any)
    end
    output << dropdown_tag('visible-md')

    output.html_safe
  end
end
