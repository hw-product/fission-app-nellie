class Nellie::JobsController < ApplicationController

  def details
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to dashboard_path
      end
      format.html do
        @job = Job.dataset_with(
          :scalars => {
            :route => ['data', 'router', 'action'],
            :status => ['status']
          }
        ).where(
          :message_id => params[:job_id],
          :account_id => current_user.run_state.current_account.id
        ).first
        if(@job)
          @state = case @job.status
                   when :complete
                     'success'
                   when :error
                     'danger'
                   else
                     'warn'
                   end
          @files = Smash[
            @job.payload.fetch(:data, :nellie, :result, :logs, {}).map do |k,v|
              begin
                file = Rails.application.config.fission_assets.get(v)
              rescue
                raise
              end
              if(file)
                [k, file.read]
              end
            end.compact
          ]
        else
          flash[:error] = "Failed to locate requested job (ID: #{params[:job_id]})"
          redirect_to dashboard_path
        end
      end
    end
  end

end
