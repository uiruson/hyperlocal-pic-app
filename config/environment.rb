require 'rubygems'
require 'bundler/setup'

require 'active_support/all'

# Load Sinatra Framework (with AR)
require 'sinatra'
require 'sinatra/activerecord'

require 'gon-sinatra'

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

# Sinatra configuration
configure do
  set :root, APP_ROOT.to_path
  set :server, :puma

  enable :sessions
  set :session_secret, ENV['SESSION_KEY'] || 'lighthouselabssecret'

  secrets = YAML.load_file( File.join(Sinatra::Application.root, 'config', 'secrets.yml') )
  set :instagram_id, secrets['instagram']['id']
  set :instagram_secret, secrets['instagram']['secret']

  set :views, File.join(Sinatra::Application.root, "app", "views")
  Sinatra::register Gon::Sinatra
end

# Set up the database and models
require APP_ROOT.join('config', 'database')
# db = URI.parse('postgres://postgres:postgres@localhost:5432/hyperlocal')

ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :host     => 'ec2-54-163-255-191.compute-1.amazonaws.com',
  :username => 'lwygkihhlhqlqa',
  :password => '6yJq5CdBbBzU-Qy_aa9EHcYb4w',
  :database => 'dburpdce044j2i',
  :encoding => 'utf8',
  :port => 5432
)

# Load the routes / actions
require APP_ROOT.join('app', 'actions')


