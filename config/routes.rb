Rails.application.routes.draw do
   namespace :api do
    namespace :v1 do
      resources :podcasts, :episodes
 

    end
  end
end
