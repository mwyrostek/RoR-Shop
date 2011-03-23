require 'spec_helper'

describe "items/new.html.erb" do
  before(:each) do
    assign(:item, stub_model(Item,
      :category_id => 1,
      :name => "MyString",
      :description => "MyString",
      :cost => "9.99"
    ).as_new_record)
  end

  it "renders new item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path, :method => "post" do
      assert_select "input#item_category_id", :name => "item[category_id]"
      assert_select "input#item_name", :name => "item[name]"
      assert_select "input#item_description", :name => "item[description]"
      assert_select "input#item_cost", :name => "item[cost]"
    end
  end
end
