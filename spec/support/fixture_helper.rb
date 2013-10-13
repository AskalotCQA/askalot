module FixtureHelper
  def fixture(name)
    File.new(Rails.root.join('spec', 'fixtures', name), 'r:utf-8')
  end
end
