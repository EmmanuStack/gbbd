Rails.application.routes.draw do
  get 'pages/home'
  get 'pages/overview'

  get 'auth/github', as: :github_auth

  match 'auth/github/callback', to: 'session#create', via: [:post, :get], as: :auth_callback

  get 'session/destroy', as: :logout

  # Defines the root path route ("/")
  root 'pages#home'
end
