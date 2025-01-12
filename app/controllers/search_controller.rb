class SearchController < ApplicationController
  include SearchHelper

  def index
    if dates_provided?
      handle_search_results
    else
      flash[:alert] = t('search.errors.missing_dates')
      @properties = Property.all
      render :index
    end
  end

  private

  def dates_provided?
    params[:start_date].present? && params[:end_date].present?
  end

  def handle_search_results
    result = search_available_properties(params)

    if result[:error]
      flash[:alert] = t('search.errors.missing_dates')
      render :index
    else
      @properties = result[:properties]
      process_properties
    end
  end

  def process_properties
    case @properties.size
    when 0
      flash.now[:alert] = t('search.errors.no_properties_available')
      render :index
    when 1
      redirect_to_property_booking(@properties.first)
    else
      flash.now[:notice] = t('search.notices.multiple_properties_available')
      render :available_properties
    end
  end

  def redirect_to_property_booking(property)
    redirect_to new_property_booking_path(
      property,
      start_date: params[:start_date],
      end_date: params[:end_date],
      guest_count: params[:guest_count]
    )
  end
end
