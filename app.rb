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
	# erb :index
	File.read(File.join('public', 'index.html'))
end

get "/dashboard" do
	authenticate!

	@rep = Reptile.all(:user_id => current_user.id)	# grabs all reptiles owned by current user
	erb :dashboard
end

get "/addnew" do
	if(Reptile.all(:user_id => current_user.id).count >= 10 && !current_user.paid) # if user has reached free limit, prompts upgrade to premium
		redirect "/premium"
	end
	@count = 0
	erb :addnew
end

post "/added" do
	check = Reptile.first(:name => params["name"])	# check if reptile with same name already exists
	if(check)
		redirect "/added_failed"
	end
	newrep = Reptile.new 	# if reptile doesn't already exist, create new and add to database
	newrep.user_id = current_user.id
	newrep.name = params["name"]
	newrep.sex = params["sex"]
	newrep.species = params["species"]
	newrep.weight = params["weight"].to_i
	newrep.morph = params["morph"]
	newrep.sire_id = params["sire"].to_i
	newrep.dam_id = params["dam"].to_i
	newrep.image_url = params["url"]
	newrep.save

	redirect "/dashboard"
end

get "/added_failed" do
	# alerts user that added failed due to reptile already existing in database
	erb :added_failed 
end

get "/profile/:reptile_id" do
	# show profile of selected reptile
	@cur_rep = Reptile.first(:id => params[:reptile_id])
	if(!@cur_rep)	# performs check if sire/dam links are wrong or empty to prevent crash
		redirect "/dashboard"
	end
	erb :profile
end

get "/edit/:reptile_id" do
	# prompts edit page for selected reptile
	@cur_rep = Reptile.first(:id => params[:reptile_id])
	@count = 0
	erb :edit
end

post "/edited/:reptile_id" do
	# edits data of selected reptile
	editrep = Reptile.first(:id => params[:reptile_id])
	editrep.name = params["name"]
	editrep.sex = params["sex"]
	editrep.species = params["species"]
	editrep.weight = params["weight"].to_i
	editrep.morph = params["morph"]
	editrep.sire_id = params["sire"].to_i
	editrep.dam_id = params["dam"].to_i
	editrep.image_url = params["url"]
	editrep.save

	redirect "/profile/#{editrep.id}"
end

delete '/:reptile_id' do
  del = Reptile.first(:id => params[:reptile_id])
  del.destroy

  redirect '/dashboard'
end

get "/premium" do
	# gives user option to upgrade to premium
	erb :premium
end

post "/payday" do
	# mockup for payment and toggling user to paid user
	current_user.paid = true
	redirect "/"
end

get "/unpay" do 
	# toggles user to unpaid for testing reasons
	current_user.paid = false
	redirect "/"
end

get "/profile/:reptile_id/share" do
	# shows profile to non-user
	@cur_rep = Reptile.first(:id => params[:reptile_id])
	if(!@cur_rep)	# performs check if sire/dam links are wrong or empty to prevent crash
		redirect "/"
	end
	erb :share
end

post "/search/:reptile_name" do
	@search = Reptile.all(:name => params[:reptile_name])
	if(!search)
		redirect "/"
	end
	erb:search
end
