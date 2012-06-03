require File.dirname(__FILE__) + '/library'

module Snippets
	
	class App < Sinatra::Base
	
		get '/' do
			erb :index
		end
		
	end
	
end