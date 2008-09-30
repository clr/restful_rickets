require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../../spec_helper'
include WillPaginate

describe "/<%= table_name %>/gets<%= html_extension %>" do
  include <%= controller_class_name %>Helper
  
  before(:each) do
<% [ 1, 2 ].each do |id| -%>
    <%= file_name %>_<%= id %> = mock_model(<%= class_name %>)
<% end %>
    @<%= table_name %> = <%= class_name %>.paginate :page => params[:page]
    assigns[:<%= table_name %>] = @<%= table_name %>
  end

  it "should render list of <%= table_name %>" do
    render "/<%= table_name %>/gets<%= html_extension %>"
  end
end

