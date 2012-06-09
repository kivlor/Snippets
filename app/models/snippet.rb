module Snippets

	class Snippet
	
		include DataMapper::Resource
		
		before		:save, 		:createHash
		
		property	:id,		Serial
		property	:title,		String,		:required => true
		property	:snippet,	Text,		:required => true
		
		property	:adminhash,	String
		property	:approved,	Boolean,	:default => false
		
		property	:created,	DateTime
		property	:updated,	DateTime
		
		def createHash()
			self.adminhash = Digest::MD5.hexdigest("#{Time.now.to_f}#{self.title}")
		end
		
	end

end