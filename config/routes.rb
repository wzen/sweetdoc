Rails.application.routes.draw do
  root 'worktable#index'
  post 'worktable/create_project'
  get 'modal_view/show'
  get 'item_js/index'
  #resources :run, only:[:index]
  get 'run' => 'run#index'
  post 'run' => 'run#index'
  get 'run/markitup_preview'
  get 'test_move/hello'
  get 'item_js_code/hello'
  get 'parts/button_css_default'

  #ajax
  post 'page_value_state/save_state'
  post 'page_value_state/load_state'
  post 'page_value_state/user_pagevalue_list'
  post 'item_js/index'
  get  'modal_view/show'
  post 'test_move/hello'
  post 'run/paging'

  # Gallery
  get 'gallery/index'
  get 'gallery/grid'
  get 'gallery/detail'
  post 'gallery/save_state'
  post 'gallery/update_last_state'
  post 'gallery/load_state'
  get 'gallery/get_contents'
  get 'gallery/get_popular_and_recommend_tags'
  post 'gallery/add_bookmark'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
