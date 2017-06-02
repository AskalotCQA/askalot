class ReloadEsToImproveSearch < ActiveRecord::Migration
  def change
    [Shared::Category, Shared::Question, Shared::Tag, Shared::User].each do |model|
      model.probe.index.reload
      model.probe.index.import model.all, with: :bulk
    end
  end
end
