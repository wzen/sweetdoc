Rails.application.routes.draw do
  root to: 'gallery#grid'
  devise_for :user, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # MyPage
  get 'my_page' => 'my_page#bookmarks'
  get 'my_page/created_contents'
  post 'my_page/remove_contents'
  get 'my_page/created_items'
  get 'my_page/bookmarks'
  post 'my_page/remove_bookmark'
  get 'my_page/using_items'

  # Worktable
  get 'worktable' => 'worktable#index'
  post 'worktable' => 'worktable#index'

  # Coding
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
  post 'coding/item_preview'

  # Project
  post 'project/create'
  post 'project/get_project_by_user_pagevalue_id'
  get 'project/admin_menu'
  post 'project/update'
  post 'project/reset'
  post 'project/remove'

  # MotionCheck
  get 'motion_check' => 'motion_check#index'
  post 'motion_check' => 'motion_check#index'
  get 'motion_check/new_window'
  post 'motion_check/new_window'

  # PageValueState
  post 'page_value_state/save_state'
  post 'page_value_state/load_state'
  get 'page_value_state/load_created_projects'
  get 'page_value_state/user_pagevalue_list_sorted_update'

  # ItemJs
  get 'item_js/index'
  post 'item_js/index'
  get 'item_js_code/hello'

  # Modal
  get 'modal_view/show'

  # Run
  get 'run/markitup_preview'
  post 'run/paging'
  post 'run/save_gallery_footprint'
  post 'run/load_common_gallery_footprint'

  # Gallery
  get 'gallery/index'
  get 'gallery/grid'
  get 'gallery/detail'
  match 'gallery/detail/:g_at' => 'gallery#detail', via: :get
  get 'gallery/full_window'
  match 'gallery/detail/w/:g_at' => 'gallery#full_window', via: :get
  get 'gallery/embed'
  match 'gallery/detail/e/:g_at' => 'gallery#embed', via: :get
  get 'gallery/embed_with_run'
  post 'gallery/embed_with_run'
  post 'gallery/save_state'
  post 'gallery/update_last_state'
  get 'gallery/get_popular_and_recommend_tags'
  post 'gallery/add_bookmark'
  post 'gallery/remove_bookmark'
  resources :gallery ,only: [:thumbnail] ,param: :access_token do
    member do
      get 'thumbnail'
    end
  end

  # ItemGallery
  get 'item_gallery' => 'item_gallery#index'
  get 'item_gallery/index'
  get 'item_gallery/preview'
  match 'item_gallery/preview/:ig_at' => 'item_gallery#preview', via: :get
  post 'item_gallery/upload_user_used'
  post 'item_gallery/save_state'
  post 'item_gallery/add_user_used'
  post 'item_gallery/remove_user_used'
  post 'item_gallery/edit'
  post 'item_gallery/delete'

  # Upload
  post 'upload' => 'upload#index'
  post 'upload/item'
  post 'upload/upload_thumbnail'

  # ConfigMenu
  post 'config_menu/design_config'
  post 'config_menu/method_values_config'
  post 'config_menu/preload_image_path_select_config'

  # ItemImage
  post 'item_image/create_img'
  post 'item_image/remove_worktable_project_img'
  post 'item_image/remove_worktable_item_img'
  post 'item_image/remove_gallery_img'

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
