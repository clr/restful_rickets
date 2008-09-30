<div class="ext_style">
  <div class="header"><%= singular_name.capitalize %>: <%%= @<%= singular_name %>.name %></div>

<%% form_for( @<%= singular_name %>, :url => <%= singular_name %>_path ) do |f| %>
  <table class="form_area">
    <tbody>
      <tr class="top_padding">
        <td class="label">&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
<% attributes.each do |attribute| -%>
      <tr>
        <td class="label"><%= attribute.column.human_name %>:</td>
        <td><%%= f.<%= attribute.field_type %> :<%= attribute.name %><%= attribute.field_type.to_s == "text_field" ? ', :class => "string"' : '' %> %></td>
      </tr>
<% end -%>
    </tbody>
    
    <tfoot>
      <tr>
        <td colspan="2">
          <button type="submit">Save</button>
          <button type="button" onclick="document.location='<%%= <%= plural_name %>_path %>';return false;">Cancel</button>
        </td>
    </tfoot>
  </table>
<%% end %>
</div>

