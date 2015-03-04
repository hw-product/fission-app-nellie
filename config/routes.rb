Rails.application.routes.draw do
  instance_exec(
    :nellie, 'v1/github/nellie',
    &FissionApp::Repositories.repositories_routes
  )

  namespace :nellie do
    get 'dashboard', :to => 'dashboard#index', :as => :dashboard
    get 'job/:job_id', :to => 'jobs#details', :as => :job
    get 'jobs', :to => 'jobs#all', :as => :jobs
    resources :repository, :only => [:show]
  end
end
