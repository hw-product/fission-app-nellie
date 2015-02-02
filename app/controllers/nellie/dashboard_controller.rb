class Nellie::DashboardController < ApplicationController

  def index
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to dashboard_path
      end
      format.html do
        @dataset = Job.dataset_with(
          :scalars => {
            :repository_name => [:data, :github, :repository, :full_name],
            :status => [:status]
          }
        ).where(:account_id => @account.id)
        @data = Smash[
          @product.repositories_dataset.where(:account_id => @account.id).all.map do |repo|
            [
              repo.name,
              Smash.new(
                :complete => @dataset.where(:repository_name => repo.name, :status => 'complete'),
                :error => @dataset.where(:repository_name => repo.name, :status => 'error'),
                :in_progress => @dataset.where(:repository_name => repo.name, :status => 'in_progress')
              )
            ]
          end
        ]
      end
    end
  end

end
