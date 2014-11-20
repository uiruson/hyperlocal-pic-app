# Require config/environment.rb
require ::File.expand_path('../config/environment',  __FILE__)

set :app_file, __FILE__
run Sinatra::Application
set :database, ENV['DATABASE_URL'] || 'postgres://localhost/hyperlocal'