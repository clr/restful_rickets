<div id="context_menu_div" class="contextMenu">
  <ul>
    <li><%%= link_to( "<div>New...</div>", <%= singular_name %>_path( :id => 0 ), :class => :new ) %></li>
    <li><%%= link_to_function( "<div>Edit...</div>", "Rickets.redirectToSelectedRow( $('#datagrid_tbody') )", :class => :edit ) %></li>
    <li><%%= link_to_function( "<div>Delete...</div>", "Rickets.destroySelectedRow( $('#datagrid_tbody') )", :class => :destroy ) %></li>
  </ul>
</div>
<div class="ext_style">
  <div class="header">Listing <%= plural_name.capitalize %></div>
  <div class="button_bar">
    <div><%%= link_to( "<div>New...</div>", <%= singular_name %>_path( :id => 0 ), :class => :new ) %></div>
    <div class="separator"></div>
    <div><%%= link_to_function( "<div>Edit...</div>", "Rickets.redirectToSelectedRow( $('#datagrid_tbody') )", :class => :edit ) %></div>
    <div class="separator"></div>
    <div><%%= link_to_function( "<div>Delete...</div>", "Rickets.destroySelectedRow( $('#datagrid_tbody') )", :class => :destroy ) %></div>
     <form method="get" action="">
      <button type="submit" class="search"></button>
      <div class="search">Search:
        <input type="text" name="search" class="autocomplete" autocomplete="off" value="<%%= params[:search] %>" />
      </div>
    </form>
  </div>
  <table class="list">

    <thead>
      <tr>
<% attributes.each do |attribute| -%>
        <th><%%= rickets_header "<%= attribute.name %>", "<%= attribute.column.human_name %>" %></th>
<% end -%>
        <th><%%= rickets_header "updated_at", "Updated At" %></th>
      </tr>
    </thead>

    <tbody id="datagrid_tbody">
  <%% @<%= plural_name %>.each do |<%= singular_name %>| %>
      <tr ondblclick="Rickets.showRow( this );"onclick="Rickets.selectRow( this );" id="<%%= <%= singular_name %>_path( :id => <%= singular_name %>.id ) %>">
<% attributes.each do |attribute| -%>
        <td><%%=h <%= singular_name %>.<%= attribute.name %> %></td>
<% end -%>
        <td><%%=h <%= singular_name %>.updated_at %></td>
      </tr>
  <%% end %>
    </tbody>

    <tfoot>
      <tr>
        <td colspan="<%= attributes.length + 1 %>">
          <div class="pagination_info">
             <%%= page_entries_info @<%= plural_name %> %>
          </div>
          <%%= will_paginate @<%= plural_name %>, :prev_label => "<span class='prev'>&nbsp;&nbsp;&nbsp;&nbsp;</span>", :next_label => "<span class='next'>&nbsp;&nbsp;&nbsp;&nbsp;</span>" %>
        </td>
      </tr>
    </tfoot>

  </table>
</div>
<%% javascript_tag do -%>
$( '#datagrid_tbody tr' ).contextMenu( 'context_menu_div', { 
  onContextMenu: function( event ) {
    Rickets.selectRow( event.currentTarget );
    return true;
  }
} );
$( 'input.autocomplete' ).autocomplete( { ajax: "<%%= auto_completes_path( :resource => '<%= singular_name %>' ) %>" } );
<%% end -%>

