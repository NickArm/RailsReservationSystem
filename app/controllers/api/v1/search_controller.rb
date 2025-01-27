class Api::V1::SearchController < ApplicationController
    include SearchHelper
    def index
        if dates_provided?
          result = search_available_properties(params)

          if result[:error]
            render json: { error: result[:error] }, status: :unprocessable_entity
          else
            render json: result[:properties], status: :ok
          end
        else
          render json: { error: 'Start date and end date are required' }, status: :unprocessable_entity
        end
      end

      private

      def dates_provided?
        params[:start_date].present? && params[:end_date].present?
      end
end
