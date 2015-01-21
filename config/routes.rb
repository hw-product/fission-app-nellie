Rails.application.routes.draw do
  instance_exec(
    :nellie, 'v1/github/nellie',
    &FissionApp::Repositories.repositories_routes
  )

  instance_exec(
    :nellie,
    &FissionApp::Jobs.jobs_routes
  )

  namespace :nellie do
    get 'dashboard', :to => 'dashboard#index', :as => :dashboard
    resources :repository, :only => [:show]
  end
end
