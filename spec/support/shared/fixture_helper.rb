module Shared::FixtureHelper
  def fixture(name)
    File.new(Rails.root.join('spec/fixtures', name), 'r:utf-8')
  end

  def test_fixture_path(name)
    Rails.root.join('spec/fixtures', name)
  end
end
