import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown", "bell", "badge"];

  connect() {
  }

  disconnect() {
  }

  // markAsRead() {
  //   console.log("markAsRead");
  //   return fetch("/notifications/mark_as_read", {
  //     method: "PATCH",
  //     headers: { "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }
  //   });
  // }

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
    const notificationId = event.currentTarget.dataset.notificationId; // Get the notification ID

    try {
      await fetch(`/notifications/${notificationId}/mark_as_read`, { // Send request with ID
        method: "PATCH",
        headers: { "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }
      });

      await this.deleteReadNotifications(); // Cleanup
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
