import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";

// Import the specific controller explicitly
import TaxesController from "./controllers/taxes_controller";

// Initialize Stimulus

const application = Application.start();

// Dynamically load all controllers from the "controllers" folder
// const context = require.context("./controllers", true, /\.js$/);
// application.load(definitionsFromContext(context));

// Explicitly register the TaxesController
application.register("taxes", TaxesController);

// Export the Stimulus application if needed elsewhere
export { application };
