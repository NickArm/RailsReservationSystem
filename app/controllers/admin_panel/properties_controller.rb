module AdminPanel
  class PropertiesController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_property, only: [ :show, :edit, :update, :destroy ]
    layout 'admin'

    def index
      @properties = current_admin.properties
    end

    def show
    end

    def new
      @property = Property.new
    end

    def edit
    end
    def create
      @property = current_admin.properties.build(property_params)

      if @property.save
        redirect_to properties_path, notice: 'Property was successfully created.'
      else
        flash.now[:alert] = 'There was an error creating the property. Please check the form.'
        render :new
      end
    end

    def update
      if @property.update(property_params)
        redirect_to properties_path, notice: 'Property updated successfully.'
      else
        render :edit
      end
    end

    def destroy
      @property.destroy
      redirect_to properties_path, notice: 'Property deleted successfully.'
    end

    private

    def set_property
      @property = current_admin.properties.find(params[:id])
    end

    def property_params
      params.require(:property).permit(
        :name, :address, :description, :country, :contact_email,
        :max_guests, :price, :min_days_stay, :max_days_stay,
        :weekly_discount, :monthly_discount
      )
    end
  end
end
