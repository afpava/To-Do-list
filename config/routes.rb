Rails.application.routes.draw do
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  get 'login_google' , to: redirect('/auth/google_oauth2'), as: 'login_google'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout' => 'sessions#destroy'


  resources :sessions , except: [:edit, :update]
  resources :users do
      resources :tasks, except: [:index] do
        member do
           patch :complete
        end
      end
  end

  root 'users#index'
end
