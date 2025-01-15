import { Application } from "@hotwired/stimulus";
import controllers from "./controllers";

const application = Application.start();
application.load(controllers);
