require 'test/unit'

begin
  require File.dirname(__FILE__) + '/../../../../config/environment'
rescue LoadError
  require 'rubygems'

  # !!TODO Need to automate testing Rails > 2.1 and Rails < 2.1
  # gem 'activerecord',   '=2.0.2'
  # gem 'activesupport',  '=2.0.2'
  # gem 'actionpack',     '=2.0.2'
  # gem 'activeresource', '=2.0.2'

  gem 'activerecord'
  gem 'actionpack'
  
  require 'active_record'
  require 'active_record/version'
  require 'action_controller'
end

require File.dirname(__FILE__) + '/../lib/acts_as_boolean'
require File.dirname(__FILE__) + '/person'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'sqlite3')

load(File.dirname(__FILE__) + '/schema.rb')

