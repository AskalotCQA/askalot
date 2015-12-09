module Shared::FixtureHelper
  def fixture(name)
    File.new(Rails.root.join('components', 'shared', 'spec', 'fixtures', name), 'r:utf-8')
  end
end
