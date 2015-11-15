module University
class Document < ActiveRecord::Base
  include Authorable
  include Deletable
  include Editable
  include Watchable

  belongs_to :group, counter_cache: true

  has_many :questions

  validates :title, presence: true, length: { minimum: 2, maximum: 140 }
  validates :text,  presence: true, length: { minimum: 2 }

  self.table_name = 'documents'
end
end
