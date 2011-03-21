require 'spec_helper'

describe "categories/edit.html.erb" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :title => "MyString",
      :level => 1,
      :ancestor => 1
    ))
  end

  it "renders the edit category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => categories_path(@category), :method => "post" do
      assert_select "input#category_title", :name => "category[title]"
      assert_select "input#category_level", :name => "category[level]"
      assert_select "input#category_ancestor", :name => "category[ancestor]"
    end
  end
end
