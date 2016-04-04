require 'yaml'
require "sinatra/base"
require "sinatra/reloader" if  :development
require "sinatra/json"
require "sinatra/cookies"
require "sinatra/multi_route"
require 'sinatra/activerecord'
require 'restclient'
require 'haml'
require 'mustache'
require 'date'
require "logger"
#require 'rack-google-analytics'

#include dirs
INC_DIRS = {"ext" => ["Hash"] , "models" => ["models"] , "lib" => [] }
INC_DIRS.each {  |k,v| v.each {|file| require_relative "#{k}/#{file}.rb" } }

module SinatraApp
  class App < Sinatra::Base
    configure :development do
      puts "==================="
      puts "IN DEVELOPMENT MODE"
      puts "==================="
      register Sinatra::Reloader
      INC_DIRS.each {  |k,v| v.each {|file| also_reload "#{k}/#{file}.rb" } }
    end

    use Rack::Session::Cookie, :key => 'rack.session',
                               :expire_after => 2592000, # In seconds
                               :path => '/',
                                :secret => 'yaw3@usteDre*2b'
    #use Rack::GoogleAnalytics, :tracker => ''

    configure :production, :development do
      enable :logging
    end

    configure do
      #set :google_analytics_id, ''
      set :root, File.dirname(__FILE__)
      conf = YAML.load_file("config/config.yml").merge(YAML.load_file("config/#{ENV["RACK_ENV"]}.yml"))
      set :config , conf
      set :alertMessages , YAML.load_file("config/messages.yml")
    end

    before do
      @message = {}
      if !params[:message].nil?
        @message = settings.alertMessages[params[:message]]
      end
      $session = session
      $settings = settings
      $logger = Logger.new('logs/common.log','weekly')
      $logger.level = Logger::INFO
      $logger.level = Logger::DEBUG if :development
    end

    before '/ws/protected/*' do
        protected!
    end

    before '/protected/*' do
        protected!
    end

  #########################
  ## Helpers
  #########################

  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      return true if not $settings["protected"]["enable_auth"]
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [$settings.conf["protected"]["username"],$settings.conf["protected"]["password"]]
    end
  end

  #########################
  ## Web Services
  #########################

  get '/ws/healthcheck/?' do
    json({ :success => true })
  end

  get '/ws/protected/reload-config/?' do
    conf = YAML.load_file("config/config.yml").merge(YAML.load_file("config/#{ENV["RACK_ENV"]}.yml"))
    $settings.config = conf
    json({ :success => true })
  end


  #########################
  ## Form Processing
  #########################


  #########################
  ## Front End
  #########################

  get '/?' do

  end

  #########################
  ## Error Handling
  #########################

   not_found do
     "Page not found"
   end

  end #class
end #module
