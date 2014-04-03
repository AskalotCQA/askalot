class AddDeletableToFollowingsAndWatchings < ActiveRecord::Migration
  def change
    models = [:followings, :watchings]

    models.each do |model|
      add_column model, :deleted_at, :timestamp
      add_column model, :deleted, :boolean, null: false, default: false
      add_reference model, :deletor, null: true, index: true
    end
  end
end
