# app/controllers/admins/sessions_controller.rb
class Admin::SessionsController < Devise::SessionsController
    # You can override methods here, e.g., `create`, `destroy`

    # Customize the login behavior
    def create
      super
    end
end
