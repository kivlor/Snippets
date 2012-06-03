DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

require File.dirname(__FILE__) + '/models/snippet.rb'

DataMapper.finalize.auto_upgrade!