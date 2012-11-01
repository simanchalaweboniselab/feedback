Feedback::Application.routes.draw do

  get "home/index"

  resources :users, :only => [] do
    get :new_password, :on => :member
    put :create_password, :on => :member
    put :update_feedback, :on => :member
    get :change_password, :on => :member
    put :update_password, :on => :member
    put :update_reset_password, :on => :member
    get :reset_password, :on => :member
    get :give_feedback, :on => :collection
    get :received_feedback, :on => :collection
    get :received_feedback_search, :on => :collection
    get :forgot_password, :on => :collection
    post :forgot_password_reset, :on => :collection
  end

  namespace :admin do
    resources :admins, :only => [:index] do
      get :add_user, :on => :collection
      post :create_user, :on => :collection
      get :assigned_feedback_list, :on => :collection
      get :assigned_feedback_search, :on => :collection
      get :reset_password, :on => :member
      put :update_password, :on => :member
    end
    resources :users, :only => [:index] do
      get :assign_user, :on => :collection
      get :get_from_user_list, :on => :collection
      get :get_to_user_list, :on => :collection
      get :create_assign_user, :on => :collection
      #get :assigned_feedback_search, :on => :collection
      get :given_feedback_search, :on => :collection
      get :received_feedback_search, :on => :collection
      get :to_feedback, :on => :member
      get :from_feedback, :on => :member
      delete :delete_user, :on => :member
      get :reset_password, :on => :member
      #get :assigned_feedback, :on => :member
    end
  end
  resources :user_sessions, :only => [:new, :create, :destroy]
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
