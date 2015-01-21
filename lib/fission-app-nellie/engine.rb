require 'fission-app-nellie'

module FissionApp
  module Nellie
    class Engine < ::Rails::Engine

      config.to_prepare do |config|
        product = Fission::Data::Models::Product.find_by_internal_name('nellie')
        unless(product)
          product = Fission::Data::Models::Product.create(
            :name => 'Nellie',
            :vanity_dns => 'nellie.ci'
          )
        end
        feature = Fission::Data::Models::ProductFeature.find_by_name('nellie_full_access')
        unless(feature)
          feature = Fission::Data::Models::ProductFeature.create(
            :name => 'nellie_full_access',
            :product_id => product.id
          )
        end
        unless(feature.permissions_dataset.where(:name => 'nellie_full_access').count > 0)
          args = {:name => 'nellie_full_access', :pattern => '/nellie.*'}
          permission = Fission::Data::Models::Permission.where(args).first
          unless(permission)
            permission = Fission::Data::Models::Permission.create(args)
          end
          unless(feature.permissions.include?(permission))
            feature.add_permission(permission)
          end
        end
      end

      # @return [Array<Fission::Data::Models::Product>]
      def fission_product
        [Fission::Data::Models::Product.find_by_internal_name('nellie')]
      end

      # @return [Hash] navigation
      def fission_navigation(product, user)
        {
          'Nellie' => {
            'Dashboard' => Rails.application.routes.url_helpers.nellie_dashboard_path,
            'Repositories' => Rails.application.routes.url_helpers.nellie_repositories_path,
            'Jobs' => Rails.application.routes.url_helpers.nellie_jobs_path
          }.with_indifferent_access
        }.with_indifferent_access
      end

      # @return [Hash] dashboard information
      def fission_dashboard(*_)
        {
          :nellie_dashboard => {
            :title => 'Nellie',
            :url => Rails.application.routes.url_for(
              :controller => 'nellie/dashboard',
              :action => :index,
              :only_path => true
            )
          }
        }
      end

    end
  end
end
