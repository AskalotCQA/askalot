class Activity < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :initiator, class_name: :User

  #TODO(poizl) rm this shit when on rails 4.1.0, see deletable.rb
  belongs_to :resource, -> { self.included_modules.include?(Deletable) ? self.deleted_or_not : self }, polymorphic: true

  default_scope -> { where.not(resource_type: [View, Vote]) }

  symbolize :action, in: ACTIONS
end

