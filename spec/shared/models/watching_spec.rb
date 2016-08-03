require 'spec_helper'

let(:user_watcher)    { create :user }
let!(:category)       { create :category, name: 'Ostatné' }
let!(:watching)       { create :watching, watcher: user_watcher, watchable: category }


expect(category.assignments.count).to eql(1)
