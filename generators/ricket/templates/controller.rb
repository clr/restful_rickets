class <%= controller_class_name %>Controller < ApplicationController

  before_filter :prepare_restful_interpretation

  # Plural methods.
  def gets
    parse_search
    parse_sort_order
    
    @<%= table_name %> = <%= class_name %>.paginate :page => params[:page], :per_page => 7, :conditions => @conditions, :order => @order

    respond_to do |format|
      format.html
    end
  end

  # Singular methods.
  def get
    respond_to do |format|
      format.html
    end
  end

  def post
    respond_to do |format|
      if @<%= file_name %> = <%= class_name %>.create( params[:<%= file_name %>] )
        flash[:notice] = '<%= class_name %> was successfully created.'
        format.html { redirect_to( <%= file_name %>_url( @<%= file_name %> ) ) }
      else
        format.html { render :action => 'get' }
      end
    end
  end

  def put
    respond_to do |format|
      if @<%= file_name %>.update_attributes( params[:<%= file_name %>] )
        flash[:notice] = '<%= class_name %> was successfully updated.'
        format.html { redirect_to( <%= file_name %>_url( @<%= file_name %> ) ) }
      else
        format.html { render :action => 'get' }
      end
    end
  end

  def delete
    @<%= file_name %>.destroy

    respond_to do |format|
      format.js
    end
  end

  protected
    def prepare_restful_interpretation
      case params[:grammatical_number]
      when 'plural'
        self.action_name = self.request.request_method.to_s.pluralize
        @<%= table_name %> = <%= class_name %>.find( params[:ids].split( ',' ) ) if params[:ids]
      when 'singular'
        self.action_name = self.request.request_method.to_s.singularize
        if params[:id].to_i == 0
          @<%= file_name %> = <%= class_name %>.new
        else
          @<%= file_name %> = <%= class_name %>.find( params[:id] ) if params[:id]
        end
      end
    end
    
    # Put search conditions in here.
    def parse_search
      return false unless params[:search]
      @conditions ||= []
      %w( name ).each do |column|
        @conditions << ActiveRecord::Base.send( :sanitize_sql_array, [ "LOWER(#{ column }) LIKE ?", "%%#{ params[:search] || "" }%%" ] )
      end
    end

    # Put 'order by' style conditions in here.
    def parse_sort_order
      return false unless params[:sort_order]
      order_by ||= []
      params[:sort_order].split( ';' ).each do |pair|
        column, direction = pair.split( ':' )
        order_by << "#{ column } #{ direction == 'up' ? 'DESC' : 'ASC' }"
      end
      @order = order_by * ", "
    end

    # Put filtering conditions in here, for enumerated column data.
    def parse_filter
      @conditions ||= []
      %w( name ).each do |column|
        param_key = ( column + "_filter" ).to_sym
        if params[ param_key ] && params[ param_key ].length > 0 
          field = field_of_interest( column )
          @conditions << ActiveRecord::Base.send( :sanitize_sql_array, [ "LOWER(#{ column.pluralize }.#{ field }) LIKE ?", '%' + params[ param_key ].clean_query_string + '%' ] ) if ( !field.nil? && params[ param_key ].clean_query_string.length > 0 )
        end
      end
    end

end
