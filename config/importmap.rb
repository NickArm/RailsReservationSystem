pin "application"
pin "admin"
pin "stimulus"
# pin "admin_calendar"

# Remove Preact pins if not in use
# pin "preact"
# pin "preact/compat", to: "preact--compat.js"
# pin "preact/hooks", to: "preact--hooks.js"

pin "@rails/ujs", to: "rails-ujs.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
# pin_all_from "app/javascript/controllers", under: "controllers"


# FullCalendar Pins
pin "@fullcalendar/core", to: "@fullcalendar--core.js"
pin "@fullcalendar/daygrid", to: "@fullcalendar--daygrid.js"
pin "@fullcalendar/timegrid", to: "@fullcalendar--timegrid.js"
pin "@fullcalendar/list", to: "@fullcalendar--list.js"

