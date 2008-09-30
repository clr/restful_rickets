<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title><%= plural_name.capitalize %></title>
  <%%= stylesheet_link_tag "jquery.ui.autocomplete" %> 
  <%%= stylesheet_link_tag "rickets/blue" %> 
	<%%= javascript_include_tag :defaults %>
	<%%= javascript_include_tag "jquery.contextmenu.r2.packed" %>
  <%%= javascript_include_tag "jquery.ui.autocomplete.ext" %>
  <%%= javascript_include_tag "jquery.ui.autocomplete.modified.20080708" %>
	<%%= javascript_include_tag "rickets/application" %>
</head>

<body>
  <%%= yield %>
</body>

</html>
