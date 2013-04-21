Yaprom::Application.routes.draw do
	namespace :admin do
		resource :projects
		resource :users
	end

	resource :users, only: [:me, :new, :create]

	get '/me' => 'me#index'
	namespace :me do
		resource :ssh_keys, only: [:new, :create, :destroy]
		post :password
	end

	get '/login' => 'site#login'
	post '/login' => 'site#auth'
	get '/logout' => 'site#logout'

	root to: 'site#index'
end
