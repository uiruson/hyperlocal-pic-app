require 'rubygems'
require 'bundler/setup'

require 'active_support/all'

# Load Sinatra Framework (with AR)
require 'sinatra'
require 'sinatra/activerecord'

require 'gon-sinatra'

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s
SECRETS = YAML.load_file( File.join(Sinatra::Application.root, '', 'secrets.yml') )


# Sinatra configuration
configure do
  set :root, APP_ROOT.to_path
  set :server, :puma

  enable :sessions
  set :session_secret, ENV['SESSION_KEY'] || 'lighthouselabssecret'


  set :instagram_id, SECRETS['instagram']['id']
  set :instagram_secret, SECRETS['instagram']['secret']

  set :views, File.join(Sinatra::Application.root, "app", "views")
  Sinatra::register Gon::Sinatra
end

# Set up the database and models
require APP_ROOT.join('config', 'database')
ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :host     => SECRETS['database']['host'],
  :username => SECRETS['database']['username'],
  :password => SECRETS['database']['password'],
  :database => SECRETS['database']['db'],
  :encoding => 'utf8',
  :port => 5432
)

# Load the routes / actions
require APP_ROOT.join('app', 'actions')


