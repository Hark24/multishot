Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :login_sessions, only: [:create]
      resources :photos, only: [:create, :destroy, :index] do
        collection do
          get :event_photos
        end
      end
      resources :contacts, only: [:create] do
        collection do
          post :add
        end
      end
      resource  :me, controller: "me" do
        resources :authentications, only: [:create]
      end
      resources :users, only: [:create] do
        collection do
          post :exist
          put :accept_terms_conditions
          get :search
          post :add_contacts
        end
      end
      resources :events, only: [:show, :create, :index] do
        collection do
          # post :changeActive
          get :search
        end
      end
      resources :invitations do
        collection do
          get :pending
          put :approve
        end
      end
    end
  end
end
