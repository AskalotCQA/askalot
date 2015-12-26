class AddAdminVisibleToAssignments < ActiveRecord::Migration
  def up
    add_column :assignments, :admin_visible, :boolean, :default => true
    add_column :assignments, :parent, :integer, :default => nil

    Shared::Assignment.where({ admin_visible: true }).each do |assignment|
      assignment.add_assignments_to_descendants
    end
  end

  def down
    remove_column :assignments, :admin_visible
    remove_column :assignments, :parent
  end
end
