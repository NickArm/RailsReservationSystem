import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list", "template"];

  add(event) {
    event.preventDefault();

    // Clone the tax template and replace TEMPLATE_INDEX with a unique value
    const uniqueIndex = new Date().getTime(); // Use a timestamp as a unique value
    const content = this.templateTarget.innerHTML.replace(/TEMPLATE_INDEX/g, uniqueIndex);

    // Append the cloned template to the list
    this.listTarget.insertAdjacentHTML("beforeend", content);
  }


  remove(event) {
    event.preventDefault();

    // Find the closest tax-item div
    const taxItem = event.target.closest(".tax-item");

    if (taxItem) {
      // Find the hidden _destroy field and set its value to "1" (mark for deletion)
      const destroyInput = taxItem.querySelector('input[name*="[_destroy]"]');
      if (destroyInput) {
        destroyInput.value = "1";
      }

      // Hide the tax item from the form (soft removal)
      taxItem.style.display = "none";
    }
  }

}
