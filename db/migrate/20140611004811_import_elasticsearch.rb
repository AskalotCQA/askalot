class ImportElasticsearch < ActiveRecord::Migration
  def up
    [Category, Question, Tag, User].each do |model|
      Question.probe.index.import model.all, with: :bulk
    end
  end

  def down
  end
end
