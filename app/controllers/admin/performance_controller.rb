# frozen_string_literal: true

module Admin
  class PerformanceController < AdminController
    before_action :set_organization, only: %i[edit apg]

    def index; end

    def edit; end

    def apg
      @apg = Objective.find(params[:apg])
    end

    def apgs
      @organizations = Organization.order(:name)
    end

    def quarterly_performance_notification
      year = params[:year]
      quarter = params[:quarter]

      CxCollection.where(aasm_state: 'draft', year:, quarter:).find_each do |cx_collection|
        UserMailer.quarterly_performance_notification(cx_collection_id: cx_collection.id).deliver_later
      end

      redirect_to admin_performance_path,
        notice: 'Quarterly performance email notication sent successfully.'
    end

    private

    def set_organization
      @organization = Organization.find_by_id(params[:id]) || Organization.find_by_abbreviation(params[:id].upcase)
    end
  end
end
