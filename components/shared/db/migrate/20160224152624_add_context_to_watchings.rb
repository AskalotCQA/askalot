class AddContextToWatchings < ActiveRecord::Migration
  def up
    add_column :watchings, :context, :integer

    ActiveRecord::Base.record_timestamps = false

    Shared::Watching.all.each do |watching|
      year = (now = watching.created_at).month >= 9 ? now.year : (now.year - 1)
      full_tree_name = "#{year}-#{(year + 1).to_s[-2..-1]}"

      watching.context = Shared::Category.find_by(full_tree_name: full_tree_name).id
      watching.save!
    end
  end

  def down
    remove_column :watchings, :context
  end
end
