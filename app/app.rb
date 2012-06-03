require File.dirname(__FILE__) + '/library'
require File.dirname(__FILE__) + '/models'

module Snippets
	
	class App < Sinatra::Base
		
		# list snippets
		get '/' do
			@snippets = Snippet.all(:approved => true, :limit => 10, :order => [:created.desc])
			
			erb :list
		end
		
		# get snippet
		get '/snippet/:id' do
		
			@snippet = Snippet.get(params[:id])
			
			if @snippet
			   erb :snippet
			else
			   @title = 'Ooops'
			   @message = 'Snippet not found'
			   
			   erb :error
			end
		end
		
		# get snippet form
		get '/submit' do
			erb :submit
		end
		
		# submit snippet
		post '/submit' do
			snippet = Snippet.create(:title => params[:title], :snippet => params[:snippet], :created => Time.now, :updated => Time.now)
			
			# TODO - add failure exception
			
			erb :submit
		end
		
		# get approve form
		get '/approve/:id' do
			erb :approve
		end
		
		# approve / ignore snippet
		post '/approve/:id' do
			erb :approve
		end
		
		# 404
		not_found do  
			status 404
			
			@title = 404
			@message = 'Page not found'
			
			erb :error
		end 
	end
	
end