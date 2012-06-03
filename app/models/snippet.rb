module Snippets

	class Snippet
	
		include DataMapper::Resource
		
		property	:id,		Serial
		property	:title,		String,		:required => true
		property	:snippet,	Text,		:required => true
		
		property	:approved,	Boolean,	:default => true
		
		property	:created,	DateTime
		property	:updated,	DateTime
		
	end

end