import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";


// Import jQuery and dependencies
import "jquery";
import "admin-lte/plugins/bootstrap/js/bootstrap.bundle.min";
import "admin-lte/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min";

// Import AdminLTE
import "admin-lte/dist/js/adminlte.min";


import TaxesController from "./controllers/taxes_controller";
import "./dataTables_custom";



const application = Application.start();

// Dynamically load all controllers from the "controllers" folder
// const context = require.context("./controllers", true, /\.js$/);
// application.load(definitionsFromContext(context));

// Explicitly register the TaxesController
application.register("taxes", TaxesController);

// Export the Stimulus application if needed elsewhere
export { application };
