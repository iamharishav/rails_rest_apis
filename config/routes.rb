Rails.application.routes.draw do
  devise_for :users
	namespace :api, defaults: { format: :json } do
		namespace :v1 do
			resources :users, :only => [:create]
			match '/login/' => 'users#login', :via => [:post], :as => :login
			resources :categories, :articles
		end
	end
end
