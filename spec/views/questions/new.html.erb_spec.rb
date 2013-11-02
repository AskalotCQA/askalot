require 'spec_helper'

describe "questions/new" do
  before(:each) do
    assign(:question, stub_model(Question).as_new_record)
  end

  it "renders new question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", questions_path, "post" do
    end
  end
end
