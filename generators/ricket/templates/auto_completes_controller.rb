# Be sure to add your resources to allowed_resources private method of the AutoCompletesController.
# This feature will not work for your new model until you do so.  You also should set the column 
# name to search in line 19, LOWER( column_name ) if it is not 'name'.  It would also be smart to
# replace this search method with a comlete Information Retrieval System, like tsearch2.
class AutoCompletesController < ApplicationController

  before_filter :prepare_restful_interpretation

  def gets
    raise "Resource '#{ params[:resource] }' not found!" unless allowed_resources.include? params[:resource]
    resource_class = params[:resource].camelize.constantize 
    case resource_class.name
    when 'treat specific classes differently'
      @objects = resource_class.find( :all,
        :conditions => [ 'inactive = 0 AND LOWER(name) LIKE ?', '%' + search_terms + '%' ], 
        :order => 'name ASC' )
    else
      @objects = resource_class.find( :all,
        :conditions => [ 'LOWER(name) LIKE ?', '%' + search_terms + '%' ], 
        :order => 'name ASC' )
    end
    respond_to do |format|
      format.js do
        render :json => @objects.collect{ |object| { :text => object.name, :url => self.send( ( params[:resource] + '_path' ).to_sym, object ) } }.flatten
      end
    end
  end

  protected
    def prepare_restful_interpretation
      case params[:grammatical_number]
      when 'plural'
        self.action_name = self.request.request_method.to_s.pluralize
      when 'singular'
        self.action_name = self.request.request_method.to_s.singularize
      end
    end

    def search_terms
      ( [ params[:val] ] + allowed_resources.collect{ |column| params[ ( column + "_filter" ).to_sym ] } ).reject( &:nil? ) * " " 
    end
    
    # Add your model resource names below, like: %w( dog cat mouse )
    def allowed_resources
      %w( )
    end
end
