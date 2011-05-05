ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'ebay_items', :action => 'home'
  map.devise_for :users
  map.resources :labels
  map.resources :releases, :collection => {:search => :get}, :has_many => :ebay_items
  map.resources :ebay_items

  map.search 'search', :controller => 'search', :action => 'search'
  map.connect '/', :controller => 'ebay_items', :action => 'home'
  map.connect 'singles', :controller => 'ebay_items', :action => 'singles'
  map.connect 'eps', :controller => 'ebay_items', :action => 'eps'
  map.connect 'lps', :controller => 'ebay_items', :action => 'lps'
  map.connect 'other', :controller => 'ebay_items', :action => 'other'
  map.all 'all', :controller => 'ebay_items', :action => 'all'
  map.connect '/:id', :controller => 'ebay_items', :action => 'show'
  map.connect '/:id/edit', :controller => 'ebay_items', :action => 'edit'

end
