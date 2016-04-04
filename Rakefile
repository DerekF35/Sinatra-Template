
# Rakefile
require './app'
require 'sinatra/activerecord/rake'

namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  
  task :environment  do |cmd|
    puts "ENV: #{ENV["RACK_ENV"]}"
  end
  
  task(:rebuild => [:drop , :create , :migrate] ) do
    puts "Rebuilt"
  end
end