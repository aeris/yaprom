Yaprom::Application.routes.draw do
	namespace :admin do
		get '/' => :index
		get :create_missing
		resources :projects, only: [:new, :create]
		resources :users, only: [:new, :create]
	end

	namespace :me do
		get '/' => :index
		post :password
		resources :ssh_keys, only: [:new, :create, :destroy]
	end

	get '/login' => 'site#login'
	post '/login' => 'site#auth'
	get '/logout' => 'site#logout'

	resources :users, only: [:show, :new, :create] do
		collection do
			get :find
		end
	end
	resources :projects, only: [:show, :new, :create] do
		post :add_member
	end
	resources :repos, only: [:show, :new, :create] do
		collection do
			get :access
		end
	end

	#mount Resque::Server, at: '/resque'
	root to: 'site#index'
end
