Dynamote::Application.routes.draw do
  
  root :to => "home#index"
  get "ajax/devices"

  get "ajax/remotes"

  get "ajax/update"

  get "remote/index"
  
  get "remote/click"
  
  get "builder/xml"
  
  get "builder/index"

  get "home/index"
  
  # Added 12/07
  
  get "home/set_layout"
  
  get "home/remote"
  
  # Added 11/20

  get "device/ajax"

  get "device/add"

  get "device/edit"

  get "device/delete"

  get "device/view"

  get "device/view_all"

  get "device/hide"

  get "device/unhide"

  post "device/do_add"

  get "account/delete"

  get "account/edit"

  get "account/login"

  get "account/logout"

  get "account/login_success"

  get "account/add_admin"

  get "account/logout_no_flash"

  post "account/do_login"

  post "account/do_add_admin"

  post "account/add"

  post "account/do_edit"

  get "account/view_all"

  get "account/first_time"

  get "/reset", :to => "account#reset"
  
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
  # match ':controller(/:action(/:id(.:format)))'
end
