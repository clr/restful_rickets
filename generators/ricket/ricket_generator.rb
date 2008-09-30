class RicketGenerator < Rails::Generator::NamedBase
  default_options :skip_migration => false
  
  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_underscore_name,
                :controller_plural_name,
                :resource_edit_path,
                :resource_generator,
                :html_extension,
                :js_extension
  alias_method  :controller_file_name,  :controller_plural_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules( @controller_name )
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names( base_name )

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
    
    @resource_generator = "scaffold"
    @html_extension = ".html.erb"
    @js_extension = ".js.rjs"
  end

  def manifest
    record do |m|
      
      # Check for class naming collisions.
      m.class_collisions( controller_class_path, "#{controller_class_name}Controller", "#{controller_class_name}Helper" )
      m.class_collisions( class_path, "#{class_name}" )

      # Controller, helper, views, and spec directories.
      m.directory File.join( 'app/models', class_path )
      m.directory File.join( 'app/controllers', controller_class_path )
      m.directory File.join( 'app/helpers', controller_class_path )
      m.directory File.join( 'app/views/layouts' )
      m.directory File.join( 'app/views', controller_class_path, controller_file_name )
      m.directory File.join( 'app/views', controller_class_path, 'auto_completes' )
      m.directory File.join( 'spec/controllers', controller_class_path )
      m.directory File.join( 'spec/models', class_path )
      m.directory File.join( 'spec/helpers', class_path )
      m.directory File.join( 'spec/fixtures', class_path )
      m.directory File.join( 'spec/views', controller_class_path, controller_file_name )
      m.directory File.join( 'spec/views', controller_class_path, 'auto_completes' )
      
      # Controller spec, class, and helper.
      m.template 'ricket:routing_spec.rb',
        File.join( 'spec/controllers', controller_class_path, "#{controller_file_name}_routing_spec.rb" )

      m.template 'ricket:controller_spec.rb',
        File.join( 'spec/controllers', controller_class_path, "#{controller_file_name}_controller_spec.rb" )
      m.template "ricket:controller.rb",
        File.join( 'app/controllers', controller_class_path, "#{controller_file_name}_controller.rb" )

      # Helper.
      m.template 'ricket:helper_spec.rb',
        File.join( 'spec/helpers', class_path, "rickets_helper_spec.rb" )
      m.template "ricket:helper.rb",
        File.join( 'app/helpers', controller_class_path, "rickets_helper.rb" )

      # Views.
      view_file_names.each do |file_name|
        m.template "ricket:#{file_name}.rb", File.join( 'app/views', controller_class_path, controller_file_name, file_name )
      end
      # Layout view.
      m.template "ricket:layout#{ html_extension }.rb", File.join( 'app/views/layouts', "#{ controller_file_name }#{ html_extension }" )
      
      # Model class, unit test, and fixtures.
      m.template 'model:model.rb',      File.join( 'app/models', class_path, "#{file_name}.rb" )
      m.template 'model:fixtures.yml',  File.join( 'spec/fixtures', class_path, "#{table_name}.yml" )
      m.template 'rspec_model:model_spec.rb',       File.join( 'spec/models', class_path, "#{file_name}_spec.rb" )

      # View specs.
      view_file_names.each do |file_name|
        m.template "ricket:#{file_name}_spec.rb", File.join( 'spec/views', controller_class_path, controller_file_name, file_name + "_spec.rb" )
      end

      # Auto_complete controller.
      auto_completes_controller_path = File.join( "app/controllers", controller_class_path, "auto_completes_controller.rb" )
      m.template "ricket:auto_completes_controller.rb", auto_completes_controller_path

      m.route_resources controller_underscore_name

      # Add class to allowable auto_complete searches.
      m.allow_auto_complete auto_completes_controller_path, controller_underscore_name.singularize

      unless options[:skip_migration]
        m.migration_template(
          'model:migration.rb', 'db/migrate', 
          :assigns => {
            :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}",
            :attributes     => attributes
          }, 
          :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
        )
      end

    end
  end

  protected
    def banner
      "Usage: #{$0} ricket ModelName [field:type field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-migration", "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
    end

    def model_name 
      class_name.demodulize
    end
    
    def view_file_names
      [ "gets#{ html_extension }", "get#{ html_extension }", "delete#{ js_extension }" ]
    end

end

module Rails
  module Generator

    module Commands
      class Create

        def route_resources( controller_underscore_name )
          sentinel = 'ActionController::Routing::Routes.draw do |map|'
          controller_singular_name = controller_underscore_name.singularize
          controller_plural_name = controller_underscore_name.pluralize
          logger.route "map #{ controller_plural_name } RESTfully"
          unless options[:pretend]
            gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
              "#{match}\n" + <<-ROUTES
  map.auto_completes 'auto_completes/:resource', :controller => 'auto_completes', :resource => /\\w+/, :grammatical_number => 'plural'

  map.#{ controller_singular_name } '#{ controller_singular_name }/:id', :controller => '#{ controller_plural_name }', :id => /\\d+/, :grammatical_number => 'singular'
  map.#{ controller_plural_name } '#{ controller_plural_name }', :controller => '#{ controller_plural_name }', :grammatical_number => 'plural'
  map.collection_of_#{ controller_plural_name } '#{ controller_plural_name }/:ids', :controller => '#{ controller_plural_name }', :ids => /(\\d,)+/, :grammatical_number => 'plural'
ROUTES
            end
          end
        end

        def allow_auto_complete( controller_file, class_name )
          unless options[:pretend]
            gsub_file controller_file, /      \%w\( /mi do |match|
              "#{ match }#{ class_name } "
            end
          end
        end

      end
    end

    class GeneratedAttribute
      def default_value
        @default_value ||= case type
          when :int, :integer               then "\"1\""
          when :float                       then "\"1.5\""
          when :decimal                     then "\"9.99\""
          when :datetime, :timestamp, :time then "Time.now"
          when :date                        then "Date.today"
          when :string                      then "\"MyString\""
          when :text                        then "\"MyText\""
          when :boolean                     then "false"
          else
            ""
        end      
      end

      def input_type
        @input_type ||= case type
          when :text                        then "textarea"
          else
            "input"
        end      
      end
    end
  end
end
