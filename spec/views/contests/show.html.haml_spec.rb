require 'rails_helper'

RSpec.describe "contests/show", type: :view do
  before(:each) do
    @contest = assign(:contest, Contest.create!(
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

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
