require 'test/unit'

begin
  require File.dirname(__FILE__) + '/../../../../config/environment'
rescue LoadError
  require 'rubygems'
  gem 'activerecord'
  gem 'actionpack'
  require 'active_record'
  require 'action_controller'
end

require File.dirname(__FILE__) + '/../lib/acts_as_boolean'
require File.dirname(__FILE__) + '/person'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'sqlite3')

load(File.dirname(__FILE__) + '/schema.rb')
