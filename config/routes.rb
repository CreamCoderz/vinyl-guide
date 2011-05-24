VinylGuide::Application.routes.draw do
  root :controller => 'ebay_items', :action => 'home'
  devise_for :users
  resources :labels
  resources :releases do
    collection do
      get :search
    end
    resources :ebay_items
  end
  resources :ebay_items

  match 'search' => 'search#search'
  match 'singles' => 'ebay_items#singles'
  match 'eps' => 'ebay_items#eps'
  match 'lps' => 'ebay_items#lps'
  match 'other' => 'ebay_items#other'
  match 'all' => 'ebay_items#all'

#  match '/:id', :controller => 'ebay_items', :action => 'show'
#  match '/:id/edit', :controller => 'ebay_items', :action => 'edit'

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
