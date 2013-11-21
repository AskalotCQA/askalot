ActsAsTaggableOn.force_lowercase = true
ActsAsTaggableOn.delimiter = [',', ' ']

ActsAsTaggableOn::Tag.class_eval do
  attr_accessor :count
end
