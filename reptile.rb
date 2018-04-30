require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
end

class Reptile
	include DataMapper::Resource
	property :id, Serial
	property :user_id, Integer
	property :name, String
	property :sex, String
	property :species, String
	property :created_at, DateTime
	property :weight, Integer
	property :morph, String
	property :sire_id, Integer	#father id
	property :dam_id, Integer	#mother id
	property :image_url, String
end

DataMapper.finalize
Reptile.auto_upgrade!