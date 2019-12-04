Rails.application.routes.draw do
  resources :organizations do
    resources :repos do
      resources :commits do
        get :master, on: :collection
      end
      resources :branches do
        get :commits, on: :member
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
