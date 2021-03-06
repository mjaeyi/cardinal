Rails.application.routes.draw do
  get 'uploads/new'

  get 'uploads/create'

  get 'patient_infos/index'

  get 'patients/plot', to: 'patients#plot'
  get 'patients/score', to: 'patients#score'
  get 'patients/risk', to: 'patients#risk'
  post 'patients/plot', to: 'patients#plot'
  post 'patients/score', to: 'patients#score'
  post 'patients/risk', to: 'patients#risk'

  get 'patients/upload', to: 'patients#upload'
  post 'patients/upload', to: 'patients#upload'

  get 'patients/genplot', to: 'patients#genplot'
  post 'patients/genplot', to: 'patients#genplot'

  get 'patients/genrisk', to: 'patients#genrisk'
  post 'patients/genrisk', to: 'patients#genrisk'

  resources :patients do
    resources :patient_infos
  end
    
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'patients#index'

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
