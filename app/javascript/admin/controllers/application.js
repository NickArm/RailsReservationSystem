import { Application } from "@hotwired/stimulus";

// Start the Stimulus application
const application = Application.start();

// Configure Stimulus for development
application.debug = true;
window.Stimulus = application;

// Export the Stimulus application instance
export { application };
