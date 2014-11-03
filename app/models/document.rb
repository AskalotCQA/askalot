class Document < ActiveRecord::Base
  include Authorable
  include Deletable
  include Editable

  belongs_to :group, counter_cache: true

  has_many :questions

  validates :title, presence: true, length: { minimum: 2, maximum: 140 }
  validates :text,  presence: true, length: { minimum: 2 }
end
