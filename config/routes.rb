Procon::Application.routes.draw do
  root :to => 'main#index'
  devise_for :people

  resources :proposed_events
  resources :locations
  resources :schedules do
    member do
      get :health
    end
  end

  resources :registration_rules
  resources :events do
    member do
      get :available_people
      post :signup, :to => "signup#signup", :as => 'signup'
      post :dropout, :to => "signup#dropout", :as => 'dropout'
    end
    
    resources :attendances do
      collection do
        get :email_list
        get :signup_sheet, :to => "attendances#signup_sheet_form"
        post :signup_sheet
        get :children
      end
    end
  end

  resources :site_templates do
    resources :attached_images
  end

  resources :virtual_sites
  match 'c/:context' => 'main#index'
  match 'c/:context/:controller/:action/:id.:format' => '#index'
  match 'c/:context/:controller/:action/:id' => '#index'
  match ':controller/service.wsdl' => '#wsdl'
  match '/:controller(/:action(/:id))'
end
