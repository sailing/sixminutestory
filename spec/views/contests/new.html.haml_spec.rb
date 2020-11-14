require 'rails_helper'

RSpec.describe "contests/new", type: :view do
  before(:each) do
    assign(:contest, Contest.new(
      :title => "MyText",
      :description => "MyText",
      :allow_multiple_entries => false,
      :terms => "MyText",
      :prompt => nil,
      :user => nil,
      :duration => "",
      :approved => false
    ))
  end

  it "renders new contest form" do
    render

    assert_select "form[action=?][method=?]", contests_path, "post" do

      assert_select "textarea[name=?]", "contest[title]"

      assert_select "textarea[name=?]", "contest[description]"

      assert_select "input[name=?]", "contest[allow_multiple_entries]"

      assert_select "textarea[name=?]", "contest[terms]"

      assert_select "input[name=?]", "contest[prompt_id]"

      assert_select "input[name=?]", "contest[user_id]"

      assert_select "input[name=?]", "contest[duration]"

      assert_select "input[name=?]", "contest[approved]"
    end
  end
end
