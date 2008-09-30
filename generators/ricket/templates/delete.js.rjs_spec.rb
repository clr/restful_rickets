require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../../spec_helper'

describe "/<%= table_name %>/delete<%= js_extension %>" do
  include <%= controller_class_name %>Helper
  
  before do
    @<%= file_name %> = mock_model( <%= class_name %> )
    @<%= file_name %>.stub!( :id ).and_return( 1 )
<% for attribute in attributes -%>
    @<%= file_name %>.stub!(:<%= attribute.name %>).and_return(<%= attribute.default_value %>)
<% end -%>
    assigns[:<%= file_name %>] = @<%= file_name %>
  end

  it "should remove the <%= file_name %> from the table" do
    render "/<%= table_name %>/delete<%= js_extension %>"
#    response.should have_rjs( :fade, @<%= file_name %>.id.to_s )
  end
end

