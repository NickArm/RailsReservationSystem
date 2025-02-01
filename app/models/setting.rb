class Setting < ApplicationRecord
    has_one_attached :logo

    validates :company_email, :notifications_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
