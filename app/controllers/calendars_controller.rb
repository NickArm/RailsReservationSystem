class CalendarsController < ApplicationController
  before_action :set_property
  layout 'admin'

  def index
    if request.format.html?
      @property = Property.find(params[:property_id])
      render :index
    else
      @calendars = @property.calendars
      render json: @calendars.map { |calendar|
        {
          id: calendar.id,
          title: calendar.price ? "€#{calendar.price}" : 'Unavailable',
          start: calendar.date,
          end: calendar.date,
          color: calendar.status == 'closed' ? 'red' : 'green'
        }
      }
    end
  end

  def create
    begin
      start_date = Date.parse(params[:start])
      end_date = Date.parse(params[:end])

      (start_date..end_date).each do |date|
        calendar = @property.calendars.find_or_initialize_by(date: date)
        calendar.assign_attributes(price: params[:price], status: params[:status])

        unless calendar.save
          render json: { error: "Failed to save calendar entry for #{date}: #{calendar.errors.full_messages.join(", ")}" },
                 status: :unprocessable_entity
          return
        end
      end

      render json: { message: 'Calendar entries updated successfully' }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def destroy
    calendar = @property.calendars.find(params[:id])
    calendar.destroy
    head :ok
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end
end
