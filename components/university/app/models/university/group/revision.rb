module University
class Group
  class Revision < ActiveRecord::Base
    include Shared::Deletable

    belongs_to :group
    belongs_to :editor, class_name: :'Shared::User'

    self.table_name = 'group_revisions'

    def self.create_revision!(editor, group)
      revision             = Group::Revision.new
      revision.editor      = editor
      revision.group       = group
      revision.title       = group.title
      revision.description = group.description
      revision.visibility  = group.visibility

      revision.save!
      revision
    end
  end
end
end
