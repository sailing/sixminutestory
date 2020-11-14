require 'rails_helper'

RSpec.describe "contests/index", type: :view do
  before(:each) do
    assign(:contests, [
      Contest.create!(
        :title => "MyText",
        :description => "MyText",
        :allow_multiple_entries => false,
        :terms => "MyText",
        :prompt => nil,
        :user => nil,
        :duration => "",
        :approved => false
      ),
      Contest.create!(
        :title => "MyText",
        :description => "MyText",
        :allow_multiple_entries => false,
        :terms => "MyText",
        :prompt => nil,
        :user => nil,
        :duration => "",
        :approved => false
      )
    ])
  end

  it "renders a list of contests" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
