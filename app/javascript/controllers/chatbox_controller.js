import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chatbox"
export default class extends Controller {
  static targets = ["box", "input"];

  connect() {
  }

  toggle() {
    this.boxTarget.classList.toggle("d-none");

    if (!this.boxTarget.classList.contains("d-none")) {
      window.dispatchEvent(new Event("chatbox:opened"));
    }
  }

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault();
      this.element.requestSubmit();
    }
  }
}
