# frozen_string_literal: true

module Api
  module V1
    class ServiceProvidersController < ::ApiController
      def index
        respond_to do |format|
          format.json do
            render json: ServiceProvider.includes(:organization).order(:id, 'organizations.name', :name), each_serializer: ServiceProviderSerializer
          end
        end
      end
    end
  end
end
