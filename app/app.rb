require File.dirname(__FILE__) + '/models'

module Snippets
	
	class App < Sinatra::Base
		
		enable    :sessions
		register  Sinatra::Flash
		CONFIG = YAML.load_file(File.dirname(__FILE__) + "/../config/config.yml")
		
		configure do
			# site
			set :site_title, CONFIG['site']['title']
			set :site_host, CONFIG['site']['host']
			
			# email
			set :email_username, CONFIG['email']['username']
			set :email_password, CONFIG['email']['password']
			set :email_to, CONFIG['email']['to']
		end
		
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
					:to => CONFIG['email']['to'],
					:via => :smtp,
					:via_options => {
						:address => 'smtp.gmail.com',
						:port => '587',
						:enable_starttls_auto => true,
						:user_name => settings.email_username,
						:password => settings.email_password,
						:authentication => :plain,
						:domain => "HELO",
					},
					:subject => "Approve new Snippet",
					:html_body => "<a href=\"http://#{settings.site_host}/approve/#{@snippet.id}/#{@snippet.admin_hash}\">Approve #{@snippet.title}</a>",
					:body => "Approve #{@snippet.title} - http://#{settings.site_host}/approve/#{@snippet.admin_hash}"
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