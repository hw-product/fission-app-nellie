class NellieDashboardCell < DashboardCell

  def show(args)
    super
    @nellie = Product.find_by_internal_name('nellie')
    dataset = Job.dataset_with(
      :scalars => {
        :status => ['status']
      }
    ).where(
      :id => Job.current_dataset_ids,
      :account_id => current_user.run_state.current_account.id
    ).where{
      created_at > 7.days.ago
    }
    @jobs_summary = {
      :in_progress => dataset.where(:status => 'active').count,
      :error => dataset.where(:status => 'error').count,
      :complete => dataset.where(:status => 'complete').count
    }
    @recent = dataset.order(:id.desc).limit(5).all
    render
  end

end
