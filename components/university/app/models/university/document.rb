module University
class Document < ActiveRecord::Base
  include Shared::Authorable
  include Shared::Deletable
  include Shared::Editable
  include Shared::Watchable

  belongs_to :group, counter_cache: true

  has_many :questions, class_name: :'Shared::Question'

  validates :title, presence: true, length: { minimum: 2, maximum: 140 }
  validates :text,  presence: true, length: { minimum: 2 }

  self.table_name = 'documents'
end
end
