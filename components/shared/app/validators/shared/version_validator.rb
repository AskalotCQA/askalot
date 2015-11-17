module Shared
class VersionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    version = Gem::Version.create value rescue nil

    record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid')) unless version
  end
end
end
