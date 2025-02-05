import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown", "bell", "badge"];

  connect() {
  }

  disconnect() {
  }

  markAsRead() {
    fetch("/notifications/mark_as_read", {
      method: "PATCH",
      headers: { "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }
    });
    this.deleteReadNotifications();
  }

  toggle() {
    this.markAsRead();
    if (this.dropdownTarget.style.display === "none" || this.dropdownTarget.style.display === "") {
      this.dropdownTarget.style.display = "block";
      this.dropdownTarget.classList.add("show");
    } else {
      this.dropdownTarget.style.display = "none";
      this.dropdownTarget.classList.remove("show");
    }

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
