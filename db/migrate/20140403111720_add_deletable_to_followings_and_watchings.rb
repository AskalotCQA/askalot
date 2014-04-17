class AddDeletableToFollowingsAndWatchings < ActiveRecord::Migration
  def up
    models = [:followings, :watchings]

    models.each do |model|
      add_column model, :deleted, :boolean, null: false, default: false
      add_reference model, :deletor, null: true, index: true
      add_column model, :deleted_at, :timestamp
    end
  end
end
