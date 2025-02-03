import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "bell", "badge"];

  connect() {
    this.markAsRead();
  }

  markAsRead() {
    fetch("/notifications/mark_as_read", {
      method: "PATCH",
      headers: { "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }
    });
  }

  toggle() {
    this.dropdownTarget.classList.toggle("show");
    if (this.badgeTarget) {
      this.badgeTarget.style.display = "none";
    }
  }
}
