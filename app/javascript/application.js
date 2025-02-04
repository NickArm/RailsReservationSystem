import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";


// Import jQuery and dependencies
import "jquery";
import "admin-lte/plugins/bootstrap/js/bootstrap.bundle.min";
import "admin-lte/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min";

const application = Application.start();

// Dynamically load all controllers from the "controllers" folder
// const context = require.context("./controllers", true, /\.js$/);
// application.load(definitionsFromContext(context));

// Export the Stimulus application if needed elsewhere
export { application };
