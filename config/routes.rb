VinylGuide::Application.routes.draw do
  devise_for :users, :controllers => {
      :registrations => "registrations",
      :sessions => 'sessions',
      :confirmations => 'confirmations',
      :passwords => 'passwords',
  }

  resources :users do
    resources :favorites
  end

  resources :labels
  resources :releases do
    collection do
      get :search
    end
    resources :ebay_items
  end
  resources :ebay_items
  resources :comments

  namespace :admin do
    resources :genres
    resources :genre_aliases
  end

  match 'search' => 'search#search'
  match 'singles' => 'ebay_items#singles'
  match 'eps' => 'ebay_items#eps'
  match 'lps' => 'ebay_items#lps'
  match 'other' => 'ebay_items#other'
  match 'all' => 'ebay_items#all'

  root :to => 'ebay_items#home'

  match 'about/welcome' => 'pages#about'

end
