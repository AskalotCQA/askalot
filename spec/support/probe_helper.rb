RSpec.configure do |config|
  models = [Category, Question, Tag, User]

  config.before :each do
    models.each do |model|
      model.probe.index.delete
      model.probe.index.create

      model.probe.index.flush
    end
  end
end
