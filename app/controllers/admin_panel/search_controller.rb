module AdminPanel
  class SearchController < ApplicationController
    include SearchHelper
    layout 'admin'
    def new
      # Render the search form
    end

    def results
      if params[:start_date].present? && params[:end_date].present?
        result = search_available_properties(params)
        if result[:error]
          flash[:alert] = result[:error]
          redirect_to new_admin_panel_search_path
        else
          @properties = result[:properties]
        end
      else
        flash[:alert] = t('admin_panel.search.errors.missing_dates')
        redirect_to new_admin_panel_search_path
      end
    end
  end
end
