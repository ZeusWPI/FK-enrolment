FKEnrolment::Application.routes.draw do
  namespace :api, :path => "api/v2" do
    get "test" => "api#test"
    get "club" => "api#club"
    resources :members, :except => [:new, :edit] do
      resource :card, :only => [:show, :create]
      get 'clubs_for_ugent_nr'
    end
  end

  namespace :backend do
    root :to => "home#index"

    resources :members, :except => [:create, :new, :destroy] do
      post "disable", :on => :member
      match "pay", "photo", :on => :member
      post "search", :on => :collection
    end

    resources :isic_exports, :only => [:index, :create], :path => :isic do
      get "data", :on => :member
      get "photos", :on => :member
      match "import", :on => :collection
    end

    match "fk" => "fk#index"

    match "settings" => "home#settings"
    match "kassa" => "home#kassa"
  end

  # should always be the last routes-entry due to the
  # greedy nature of the :club-scope
  namespace :frontend, :path => nil, :as => nil do
    root :to => "home#index"

    get "cas/auth" => "cas#auth"
    get "cas/logout" => "cas#logout"
    match "cas/verify" => "cas#verify"

    get "eid" => "eid#auth"
    post "eid/receive" => "eid#receive"
    get "eid/logout" => "eid#logout"
    get "eid/photo" => "eid#photo"

    scope :path => ":club", :as => :registration do
      root :to => "registration#index"
      get "cas" => "cas#auth"
      get "eid" => "eid#auth"
      match "algemeen" => "registration#general", :as => :general
      match "foto" => "registration#photo", :as => :photo
      match "isic" => "registration#isic", :as => :isic
      get "succes" => "registration#success", :as => :success
    end
  end

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
