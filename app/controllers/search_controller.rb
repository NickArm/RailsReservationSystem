class SearchController < ApplicationController
  include SearchHelper

  def index
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : nil
    @guest_count = params[:guest_count].to_i if params[:guest_count].present?

    # Fetch properties based on search criteria
    if @start_date && @end_date
      @properties = search_available_properties(params)[:properties]
    end
  end

  private

  def dates_provided?
    params[:start_date].present? && params[:end_date].present?
  end

  # def handle_search_results
  #   if params[:start_date].blank? || params[:end_date].blank?
  #     @properties = Property.all
  #     flash.now[:alert] = t('search.errors.missing_dates')
  #     render :index and return
  #   end

  #   result = search_available_properties(params)

  #   if result[:properties].blank?
  #     @properties = Property.all
  #     flash.now[:alert] = t('search.errors.no_properties_available')
  #     render :index and return
  #   end

  #   @properties = result[:properties]
  #   process_properties
  # end

  def handle_search_results
    result = search_available_properties(params)

    if result[:properties].blank?
      @properties = []
      flash.now[:alert] = 'No properties available for the selected dates.'
    else
      @properties = result[:properties]
    end

    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])

    render :index
  end

  def process_properties
    case @properties.size
    when 0
      flash.now[:alert] = t('search.errors.no_properties_available')
      redirect_to search_path
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
