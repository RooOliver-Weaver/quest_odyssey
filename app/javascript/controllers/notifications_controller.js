import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown", "bell", "badge"];

  connect() {
    this.markAsRead();
    this.boundDeleteReadNotifications = this.deleteReadNotifications.bind(this);
    document.addEventListener("turbo:visit", this.boundDeleteReadNotifications);
  }

  disconnect() {
    document.removeEventListener("turbo:visit", this.boundDeleteReadNotifications);
  }

  markAsRead() {
    fetch("/notifications/mark_as_read", {
      method: "PATCH",
      headers: { "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }
    });
  }

  toggle() {
    // Check the current display state and toggle
    if (this.dropdownTarget.style.display === "none" || this.dropdownTarget.style.display === "") {
      this.dropdownTarget.style.display = "block";
    } else {
      this.dropdownTarget.style.display = "none";
      this.deleteReadNotifications();
    }

    // Hide the badge when toggled
    if (this.hasBadgeTarget) {
      this.badgeTarget.style.display = "none";
    }
  }

  deleteReadNotifications() {
    fetch("/notifications/delete_read", {
      method: "DELETE",
      headers: { "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }
    });
  }
}
