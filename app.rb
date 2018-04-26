require "sinatra"
require_relative "reptile.rb"
require_relative "authentication.rb"



#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil

get "/" do
	erb :index
end


get "/dashboard" do
	authenticate!

	@rep = Reptile.all(:userid => :current_user)
	# need something like this to grab all reptiles owned by logged in user

	erb :dashboard
end

get "/addnew" do
	erb :addnew
end

post "/added" do

	newrep = Reptile.new
	newrep.user_id = :current_user
	newrep.name = params["name"]
	newrep.sex = params["sex"]
	newrep.species = params["species"]
	newrep.age = params["age"]
	newrep.weight = params["weight"].to_i
	newrep.morph = params["morph"]
	newrep.sire_id = params["father"].to_i
	newrep.dam_id = params["mother"].to_i
	newrep.image_url = params["url"]
	newrep.save

	redirect "/dashboard"
end

get "/profile" do
	# 
	erb :profile
end