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
      get "pay", "photo", :on => :member
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

    get "fk" => "fk#index"

    get "settings" => "home#settings"
    get "kassa" => "home#kassa"
  end

  # should always be the last routes-entry due to the
  # greedy nature of the :club-scope
  namespace :frontend, :path => nil, :as => nil do
    root :to => "home#index"

    get "cas/auth" => "cas#auth"
    get "cas/logout" => "cas#logout"
    get "cas/verify" => "cas#verify"

    get "eid" => "eid#auth"
    post "eid/receive" => "eid#receive"
    get "eid/logout" => "eid#logout"
    get "eid/photo" => "eid#photo"

    scope :path => ":club", :as => :registration do
      root :to => "registration#index"
      get "cas" => "cas#auth"
      get "eid" => "eid#auth"
      get "algemeen" => "registration#general", :as => :general
      get "foto" => "registration#photo", :as => :photo
      get "isic" => "registration#isic", :as => :isic
      get "succes" => "registration#success", :as => :success
    end
  end

end
