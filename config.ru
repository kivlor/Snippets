require 'rubygems'
require 'sinatra'
require File.dirname(__FILE__) + '/app/app.rb'

use Rack::MethodOverride

run Snippets::App