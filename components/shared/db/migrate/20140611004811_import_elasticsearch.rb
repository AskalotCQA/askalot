class ImportElasticsearch < ActiveRecord::Migration
  def up
    [Shared::Category, Shared::Question, Shared::Tag, Shared::User].each do |model|
      model.probe.index.import model.all, with: :bulk
    end
  end

  def down
  end
end
