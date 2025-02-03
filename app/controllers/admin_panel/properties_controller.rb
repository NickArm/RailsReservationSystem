module AdminPanel
  class PropertiesController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_property, only: %i[show edit update destroy manage_taxes create_tax destroy_tax]
    layout 'admin'

    def index
      @properties = current_admin.properties
    end

    def show; end

    def new
      @property = Property.new
    end

    def edit; end

    def create
      @property = current_admin.properties.build(property_params)

      if @property.save
        redirect_to admin_panel_properties_path, notice: t('.success')
      else
        flash.now[:alert] = t('.error')
        render :new
      end
    end

    def update
      Rails.logger.debug { "Property Params: #{property_params.inspect}" }
      if @property.update(property_params)
        redirect_to admin_panel_properties_path, notice: t('.success')
      else
        Rails.logger.debug { "Property Errors: #{@property.errors.full_messages}" }
        flash.now[:alert] = t('.error')
        render :edit
      end
    end

    def destroy
      if @property.destroy
        redirect_to admin_panel_properties_path, notice: t('.success')
      else
        redirect_to admin_panel_properties_path, alert: t('.error')
      end
    end

    # TAXES MANAGEMENT
    def manage_taxes
      @taxes = @property.taxes
      @new_tax = @property.taxes.build
    end

    def create_tax
      @tax = @property.taxes.build(tax_params)

      if @tax.save
        respond_to do |format|
          format.html {
 redirect_to manage_taxes_admin_panel_property_path(@property), notice: t('.success') }
          format.turbo_stream
        end
      else
        respond_to do |format|
          format.html do
            flash[:alert] = @tax.errors.full_messages.to_sentence
            redirect_to manage_taxes_admin_panel_property_path(@property)
          end
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('tax_form', partial: 'admin_panel/properties/tax_form',
locals: { tax: @tax })
          end
        end
      end
    end

    def destroy_tax
      @tax = @property.taxes.find(params[:tax_id])

      if @tax.destroy
        respond_to do |format|
          format.turbo_stream
          format.html {
 redirect_to manage_taxes_admin_panel_property_path(@property), notice: t('.success')}
        end
      else
        respond_to do |format|
          format.turbo_stream {
 render turbo_stream: turbo_stream.replace('tax_errors', partial: 'shared/errors',
locals: { errors: [ 'Failed to remove tax' ] }) }
          format.html do
            flash[:alert] = t('.error')
            redirect_to manage_taxes_admin_panel_property_path(@property)
          end
        end
      end
    end

    private

    def set_property
      @property = current_admin.properties.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_panel_properties_path, alert: t('admin_panel.properties.set_property.not_found')
    end

    def tax_params
      params.expect(tax: [ :name, :rate, :rate_type, :application_case ])
    end

    def property_params
      params.expect(
        property: [ :name, :phone, :address, :country, :description, :contact_email,
        :max_guests, :min_days_stay, :max_days_stay, :weekly_discount,
        :monthly_discount,
        taxes_attributes: [ :id, :name, :rate_type, :rate, :application_case, :_destroy ] ]
      )
    end
  end
end
