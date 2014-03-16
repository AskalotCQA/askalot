class Tagging < ActiveRecord::Base
  include Deletable

  belongs_to :tag
  belongs_to :taggable, polymorphic: true
end
