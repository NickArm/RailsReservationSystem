module ApplicationHelper
    def bootstrap_class_for_flash(flash_type)
      case flash_type.to_sym
      when :success
        'success'
      when :error
        'danger'
      when :alert
        'warning'
      when :notice
        'info'
      else
        flash_type.to_s
      end
    end

    def currency_symbol(currency_code)
      case currency_code
      when 'usd'
        '$'
      when 'eur'
        '€'
      else
        ''
      end
    end
end
