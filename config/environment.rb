require 'rubygems'
require 'bundler/setup'

require 'active_support/all'

# Load Sinatra Framework (with AR)
require 'sinatra'
require 'sinatra/activerecord'
require 'pry'
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

ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :host     => 'ec2-54-163-248-144.compute-1.amazonaws.com',
  :username => 'czliyfcqxaehod',
  :password => 'sSkIzOzaJRHIuIdOs0Se9ypgf_',
  :database => 'd8l9o8p3jie214',
  :encoding => 'unicode',
  :port => 5432
)s

# Load the routes / actions
require APP_ROOT.join('app', 'actions')


