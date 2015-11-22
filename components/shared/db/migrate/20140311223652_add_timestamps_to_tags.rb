class AddTimestampsToTags < ActiveRecord::Migration
  def change
    add_column :tags, :created_at, :datetime, null: false, default: '2000-01-01 00:00:00'
    add_column :tags, :updated_at, :datetime, null: false, default: '2000-01-01 00:00:00'

    Shared::Tag.find_each do |tag|
      tag.created_at = tag.updated_at = tag.taggings.order(:created_at).limit(1).pluck(:created_at).first || DateTime.now

      tag.save!
    end
  end
end
