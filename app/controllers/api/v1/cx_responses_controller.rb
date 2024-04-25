# frozen_string_literal: true

module Api
  module V1
    class CxResponsesController < ::ApiController
      def index
        page = params.fetch(:page, 1).to_i
        size = params.fetch(:size, 500).to_i
        size = 500 if size <= 0 || size > 500

        begin
          start_date = params[:start_date] ? Date.parse(params[:start_date]).to_date : Date.parse("2023-10-01").to_date
          end_date = params[:end_date] ? Date.parse(params[:end_date]).to_date : 1.day.from_now
        rescue StandardError
          render json: { error: { message: "invalid date format, should be 'YYYY-MM-DD'", status: 400 } }, status: :bad_request and return
        end

        cx_responses = CxResponse.page(page).per(size)

        respond_to do |format|
          format.json do
            render json: cx_responses, each_serializer: CxResponseSerializer,
              meta: {
                current_page: cx_responses.current_page,
                size: cx_responses.size,
                total_pages: cx_responses.total_pages,
                total_count: cx_responses.total_count,
              },
              links: {
                self: request.original_fullpath
              }
          end
        end
      end
    end
  end
end
