Rails.application.routes.draw do
  root to: 'gallery#index'

  devise_for :user, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

  get 'worktable' => 'worktable#index'
  post 'worktable' => 'worktable#index'

  post 'coding/save_all'
  post 'coding/save_tree'
  post 'coding/update_code'
  post 'coding/save_state'
  post 'coding/add_new_file'
  post 'coding/add_new_folder'
  get 'coding/load_code'
  get 'coding/load_tree'
  post 'coding/delete_node'
  get 'coding/item'

  post 'project/create'
  get 'project/list'

  get 'motion_check' => 'motion_check#index'
  post 'motion_check' => 'motion_check#index'
  post 'motion_check/new_window'

  get 'run/markitup_preview'
  get 'test_move/hello'

  get 'parts/button_css_default'

  #ajax
  post 'page_value_state/save_state'
  post 'page_value_state/load_state'
  get 'page_value_state/user_pagevalue_last_updated_list'
  get 'page_value_state/user_pagevalue_list_sorted_update'
  get 'item_js/index'
  post 'item_js/index'
  get 'item_js_code/hello'
  get 'modal_view/show'
  post 'test_move/hello'
  post 'run/paging'

  # Gallery
  get 'gallery/index'
  get 'gallery/grid'
  get 'gallery/detail'
  match 'gallery/detail/:access_token' => 'gallery#detail', via: :get
  get 'gallery/run_window'
  match 'gallery/detail/w/:access_token' => 'gallery#run_window', via: :get
  post 'gallery/save_state'
  post 'gallery/update_last_state'
  get 'gallery/get_contents'
  get 'gallery/get_popular_and_recommend_tags'
  post 'gallery/add_bookmark'
  resources :gallery ,only: [:thumbnail] ,param: :access_token do
    member do
      get 'thumbnail'
    end
  end

  # Upload
  post 'upload' => 'upload#index'

  # Document
  get 'document/terms'
  get 'document/privacy'
  get 'document/help'
  get 'document/inquiry'
  get 'document/about'
  get 'document/referense'
  get 'document/info'

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
