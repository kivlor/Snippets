require	'bundler/setup'
Bundler.require(:default)

require File.dirname(__FILE__) + '/app/app.rb'

use Rack::MethodOverride

run Snippets::App