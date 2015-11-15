module TextcompleteHelper
  def select_textcomplete(value, options)
    raise "Must pass a hash containing 'from'." unless options.is_a?(Hash) and [:from].any? { |k| options.has_key? k }

    label   = options[:from]
    wrapper = find("##{label}").find(:xpath, './/..')

    within wrapper do
      # TODO (smolnar) figure out xpath
      all('a').each do |link|
        return link.click if link.text.strip == value
      end
    end

    raise "Could not find '#{value}' in textcomplete for '#{label}'"
  end
end
