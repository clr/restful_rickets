module RicketsHelper

  def ricket_path( object )
    object_name = ActionController::RecordIdentifier.singular_class_name(object)
    self.send( ( object_name + "_path" ).to_sym, { :id => object } )
  end

  def ricket_tab( name, url, selected )
    link_to "<div class='left'></div><div>#{ name }</div><div class='right'></div>", url, :class => ( selected ? 'selected' : '')
  end

  def rickets_header( name, printed_name )
    order_by_hash = {}
    params[:sort_order].each do |chunk|
      column, direction = chunk.split( ':' )
      order_by_hash[ column ] = direction 
    end if params[:sort_order]
    if order_by_hash.has_key? name 
      if order_by_hash[ name ] == 'down'
        order_by_hash[ name ] = 'up'
        css = 'sort_down'
      else
        order_by_hash.delete( name )
        css = 'sort_up'
      end
    else
      order_by_hash[ name ] = 'down'
    end
    sort_order_hash = order_by_hash.empty? ? {} : { :sort_order => ( order_by_hash.collect{ |key, value| "#{ key }:#{ value }" } * ';' ) }
    adjusted_params = request.symbolized_path_parameters.merge( sort_order_hash )
    link_to printed_name, url_for( adjusted_params ), :class => css
  end
  
end
