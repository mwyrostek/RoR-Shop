require 'spec_helper'

describe "categories/edit.html.erb" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :parent_id => 1,
      :name => "MyString"
    ))
  end

  it "renders the edit category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => categories_path(@category), :method => "post" do
      assert_select "input#category_parent_id", :name => "category[parent_id]"
      assert_select "input#category_name", :name => "category[name]"
    end
  end
end
