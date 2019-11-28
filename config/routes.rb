Rails.application.routes.draw do
  resources :repos do
    resources :commits do
      get :master_from_initial, on: :collection
      get :master_from_last, on: :collection
    end
    resources :branches do
      get :commits, on: :member
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "repos#index"
end
