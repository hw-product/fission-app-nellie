class Nellie::DashboardController < ApplicationController

  def index
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to dashboard_path
      end
      format.html do
        @product = Product.find_by_internal_name('nellie')
        @accounts = [@account]

        nellie_dataset = Job.dataset_with(
          :scalars => {
            :status => ['status']
          }
        ).where(
          :id => Job.current_dataset_ids,
          :account_id => current_user.run_state.current_account.id
        ).where{
          created_at > 7.days.ago
        }
        @data = Hash[
          @accounts.map do |acct|
            [
              acct,
              Hash[
                @product.repositories_dataset.where(:account_id => acct.id).all.map do |repo|
                  [repo, Smash.new(
                     :completed => nellie_dataset.last.payload[:data][:nellie][:result][:complete],
                     :logs => nellie_dataset.last.payload[:data][:nellie][:result][:logs]
                   )
                  ]
                end
              ]
            ]
          end
        ]
      end
    end
  end

end
