import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown", "bell", "badge"];

  connect() {
  }

  disconnect() {
  }

  markAsRead() {
    console.log("markAsRead");
    return fetch("/notifications/mark_as_read", {
      method: "PATCH",
      headers: { "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }
    });
  }

  toggle() {
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

  async markNotificationAsRead(event) {
    event.preventDefault();
    const targetUrl = event.currentTarget.getAttribute("href");

    try {
      await this.markAsRead();  // Wait for marking as read to complete
      await this.deleteReadNotifications();  // Wait for deletion to complete
    } catch (error) {
      console.error("Failed to process notification:", error);
    }

    window.location.href = targetUrl; // Now navigate
  }


  deleteReadNotifications() {
    return fetch("/notifications/delete_read", {
      method: "DELETE",
      headers: { "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }
    });
  }
}
