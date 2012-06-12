require File.dirname(__FILE__) + '/models'

module Snippets
	
	class App < Sinatra::Base
		
		@site_title = 'Snippets'
		@site_url = 'localhost:9393'
		
		enable    :sessions
    register  Sinatra::Flash
		
		# list snippets
		get '/' do
			@snippets = Snippet.all(:approved => true, :limit => 10, :order => [:created.desc])
			
			erb :list
		end
		
		# view snippet
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
			
			@snippet = Snippet.create(:title => params[:title], :snippet => params[:snippet], :created => Time.now, :updated => Time.now)
      
			if @snippet.save
			
				# email admin approve link
				Pony.mail(
					:to => 'kivlor@gmail.com',
					:from => 'kivlor@gmail.com',
					:subject => 'Approve new Snippet',
					:html_body => "<a href=\"http://#{@site_url}/approve/#{@snippet.id}/#{@snippet.admin_hash}\">Approve #{@snippet.title}</a>",
					:body => "Approve #{@snippet.title} - http://#{@site_url}/approve/#{@snippet.admin_hash}"
				)
				flash[:notice] = 'Snippet submitted.'
				redirect '/'
			
			else
				@error = 'Unable to insert snippet, try again...'
			end
			
			erb :submit
		end
		
		# approve snippet
		get '/approve/:id/:admin_hash' do
			
			@snippet = Snippet.get(params[:id])
			
			if @snippet and @snippet.admin_hash == params[:admin_hash]
				
				@snippet.approved = true
				@snippet.save
				
				redirect '/'
			else
				@title = 'Ooops'
				@message = 'Snippet not found'
				
				erb :error
			end
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