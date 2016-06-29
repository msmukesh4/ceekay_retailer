CeekayRetailer::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

    
    root to: 'retailer#index'

    ### Start API routes ###

   namespace :v1, defaults: {format: 'json'} do
      
      namespace :account do
         resource :session do
            get 'demo'
            post 'login'
         end

         resource :profile do
            post 'update_password'
            post 'edit_profile'
         end

         resource :dse do
            get 'get_dse_routes'
         end

         resource :retailer do
            get 'get_retailer_code_list'
            get 'get_retailer_details'
            post 'update_retailer_address'
            get 'get_my_retailers'
            get 'get_my_retailers_updated_today'
            get 'get_my_pending_retailers'
         end

      end

   end


  ### End API routes ###

  match ':controller(/:action(/:id))', :via => [:get, :post]

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
