namespace :rickets do

  desc "Copy over some rickets assets to the public directory."
  task :assets do
    puts "\nInstalling Assets..."
    # Create directories if they don't already exist.
    directory File.join( RAILS_ROOT, 'public', 'images', 'rickets', 'blue' )
    directory File.join( RAILS_ROOT, 'public', 'javascripts', 'rickets' )
    directory File.join( RAILS_ROOT, 'public', 'stylesheets', 'rickets' )
    
    source = File.join( RAILS_ROOT, 'vendor', 'plugins', 'restful_rickets', 'assets', '.' )
    destination = File.join( RAILS_ROOT, 'public' )
    cp_r( source, destination )
    puts "done."
  end

  desc "Remove some rickets assets from the public directory."
  task :unassets do
    puts "\nUninstalling Assets"
    rm_rf File.join( RAILS_ROOT, 'public', 'images', 'rickets' )
    rm_rf File.join( RAILS_ROOT, 'public', 'javascripts', 'rickets' )
    rm_rf File.join( RAILS_ROOT, 'public', 'stylesheets', 'rickets' )
  end

end
