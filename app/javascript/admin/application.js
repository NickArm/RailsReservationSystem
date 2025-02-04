// Import Stimulus and its helpers
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";


import "jquery";
import "admin-lte/plugins/bootstrap/js/bootstrap.bundle.min.js";
import "admin-lte/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js";

// Import AdminLTE
import "admin-lte/dist/js/adminlte.min.js";

// Import custom JavaScript files
import "./admin_calendar";
import "./dataTables_custom";

const application = Application.start();

import TaxesController from "./controllers/taxes_controller";
application.register("taxes", TaxesController);

export { application };

