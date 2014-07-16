Hippo::Application.routes.draw do

  resources :widgets

  resources :stencils

  root :to => 'static#index'

  match 'demo1' => 'static#demo1'
  match 'demo1/:id/dial' => 'static#demo1_dial'
  match 'demo1/:id/curr_temp' => 'static#demo1_curr_temp', :as => :demo1_curr_temp

  match 'demo2' => 'static#demo2'
  match 'demo2/:id' => 'static#demo2_history'
  match 'demo2/:action/:id' => 'static#history_data', :as => :history_data

  match 'osm' => 'static#osm'

  match 'stencils/:id/display' => 'stencils#display'
  match 'location_map_ajax' => 'stencils#location_map_ajax'
  match 'table_ajax' => 'stencils#table_ajax'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
