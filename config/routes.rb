FKEnrolment::Application.routes.draw do
  namespace :api, :path => "api/v2" do
    get "test" => "api#test"
    get "club" => "api#club"
    resources :members, :except => [:new, :edit] do
      resource :card, :only => [:show, :create]
      get 'clubs_for_ugent_nr', :on => :collection
    end
  end

  namespace :backend do
    root :to => "home#index"

    resources :members, :except => [:create, :new, :destroy] do
      post "disable", :on => :member
      match "pay", "photo", :on => :member, :via => [:get, :post, :patch]
      post "search", :on => :collection
      get "export_status", :on => :collection
      get "export_xls", :on => :collection
      post "generate_export", :on => :collection
    end

    resources :isic_exports, :only => [:index, :create], :path => :isic do
      get "data", :on => :member
      get "photos", :on => :member
      get "import", :on => :collection
    end

    match "fk" => "fk#index", :via => [:get, :post]

    match "settings" => "home#settings", :via => [:get, :post]
    match "kassa" => "home#kassa", :via => [:get, :post]
  end

  # should always be the last routes-entry due to the
  # greedy nature of the :club-scope
  namespace :frontend, :path => nil, :as => nil do
    root :to => "home#index"

    # Creata a logout_path so params can be passed to it for CAS logout
    get "logout" # don't point this to something, cack-cas will intercept this

    get "cas/auth" => "cas#auth"
    get "cas/logout" => "cas#logout"
    match "cas/verify" => "cas#verify", :via => [:get, :post]

    get "eid" => "eid#auth"
    post "eid/receive" => "eid#receive"
    get "eid/logout" => "eid#logout"
    get "eid/photo" => "eid#photo"

    scope :path => ":club", :as => :registration do
      root :to => "registration#index"
      get "cas" => "cas#auth"
      get "eid" => "eid#auth"
      get "card_type" => "registration#pick_card_type"
      match "algemeen" => "registration#general", :as => :general, :via => [:get, :post, :patch]
      match "foto" => "registration#photo", :as => :photo, :via => [:get, :post, :patch]
      match "isic" => "registration#isic", :as => :isic, :via => [:get, :post, :patch]
      get "succes" => "registration#success", :as => :success
    end
  end

end
