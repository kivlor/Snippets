require File.dirname(__FILE__) + '/library'
require File.dirname(__FILE__) + '/models'

module Snippets
	
	class App < Sinatra::Base
		
		# list snippets
		get '/' do
			# find all the snippets!
			@snippets = Snippet.all(:approved => true, :limit => 10, :order => [:created.desc])
			
			erb :list
		end
		
		# get snippet
		get '/snippet/:id' do
		
			# find snippet
			@snippet = Snippet.get(params[:id])
			
			# found? yay!
			if @snippet
			   erb :snippet
			  
			# hmmm, error then...
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
			
			# try and create snippet
			snippet = Snippet.create(:title => params[:title], :snippet => params[:snippet], :created => Time.now, :updated => Time.now)
			
			# save was successful?
			if snippet.save
				redirect '/'
			
			# doh!
			else
				@error = 'Unable to insert snippet, try again...'
			end
			
			erb :submit
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