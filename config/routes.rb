Fogatta::Application.routes.draw do

  resources :messages
  root to: "messages#index"

  match "/auth/authentication" => "sessions#authentication", as: :github_auth
  match "/signout" => "sessions#destroy", as: :signout
end
