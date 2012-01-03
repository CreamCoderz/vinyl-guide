VinylGuide::Application.routes.draw do
  devise_for :users, :controllers => {
      :registrations => "registrations",
      :sessions => 'sessions',
      :confirmations => 'confirmations',
      :passwords => 'passwords'
  }
  resources :labels
  resources :releases do
    collection do
      get :search
    end
    resources :ebay_items
  end
  resources :ebay_items
  resources :comments

  match 'search' => 'search#search'
  match 'singles' => 'ebay_items#singles'
  match 'eps' => 'ebay_items#eps'
  match 'lps' => 'ebay_items#lps'
  match 'other' => 'ebay_items#other'
  match 'all' => 'ebay_items#all'

  root :to => 'ebay_items#home'

end
