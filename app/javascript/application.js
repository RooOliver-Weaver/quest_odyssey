// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener("DOMContentLoaded", function () {
  // Select all day headers
  document.querySelectorAll(".day-header").forEach((header) => {
    header.addEventListener("click", function () {
      let day = this.getAttribute("data-day"); // Get the day from data attribute
      let checkboxes = document.querySelectorAll(`.day-slot[data-day="${day}"]`);

      // Determine if we should check or uncheck based on the first checkbox
      let shouldCheck = !checkboxes[0].checked;

      // Toggle all checkboxes for that day
      checkboxes.forEach((checkbox) => {
        checkbox.checked = shouldCheck;
      });
    });
  });
});
