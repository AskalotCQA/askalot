module University::HelpHelper
  def help_image_tag(path, options = {})
    path = image_path "screenshots/#{path}"

    image_tag(path, class: :'help-image')
  end
end
