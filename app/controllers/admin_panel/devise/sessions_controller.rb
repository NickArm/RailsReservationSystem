module AdminPanel
    module Devise
      class SessionsController < ::Devise::SessionsController
        def new
          super
        end

        def create
          super
        end

        def destroy
          super
        end
      end
    end
end
