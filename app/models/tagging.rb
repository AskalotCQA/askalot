class Tagging < ActiveRecord::Base
  include Deletable

  belongs_to :tag
  belongs_to :question
  belongs_to :author, class_name: :User # TODO (smolnar) use authorable, add counter_cache
end
