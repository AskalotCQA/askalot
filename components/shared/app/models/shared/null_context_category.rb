module Shared
  class NullContextCategory
    def method_missing(method_name, *args)
      nil
    end

    def id
      'default'
    end

    def askalot_page_url
      'default_askalot_page_url'
    end
  end
end
