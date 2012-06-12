module Snippets

	class Snippet
	
		include DataMapper::Resource
		
		before		:save, 		:create_hash
		
		property	:id,		Serial
		property	:title,		String,		:required => true
		property	:snippet,	Text,		:required => true
		
		property	:admin_hash,	String
		property	:approved,	Boolean,	:default => false
		
		property	:created,	DateTime
		property	:updated,	DateTime
		
		def create_hash()
			self.admin_hash = Digest::MD5.hexdigest("#{Time.now.to_f}#{self.title}")
		end
		
	end

end