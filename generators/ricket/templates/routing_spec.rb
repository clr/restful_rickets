require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

describe <%= controller_class_name %>Controller do
  describe "route generation" do

    it "should map { :controller => '<%= table_name %>', :action => 'gets', :method => 'get' } to /<%= table_name %>" do
      route_for( :controller => '<%= table_name %>', :action => 'gets', :method => 'get' ).should == "/<%= table_name %>"
    end
  
    it "should map { :controller => '<%= table_name %>', :action => 'get', :method => 'get' } to /<%= file_name %>" do
      route_for( :controller => '<%= table_name %>', :action => 'get', :method => 'get' ).should == "/<%= file_name %>"
    end
  
  end

  describe "route recognition" do

    it "should generate params { :controller => '<%= table_name %>', action => 'gets' } from GET /<%= table_name %>" do
      params_from( :get, "/<%= table_name %>" ).should == { :controller => '<%= table_name %>', :action => 'gets' }
    end
  
    it "should generate params { :controller => '<%= table_name %>', action => 'get' } from GET /<%= file_name %>" do
      params_from( :get, "/<%= file_name %>" ).should == { :controller => '<%= table_name %>', :action => 'get' }
    end

  end
end
