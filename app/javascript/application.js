// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener("turbo:load", function () {
  document.querySelectorAll(".day-header").forEach((header) => {
    header.addEventListener("click", function () {
      let day = this.getAttribute("data-day");
      let checkboxes = document.querySelectorAll(`.day-slot[data-day="${day}"]`);

      let shouldCheck = !checkboxes[0].checked;

      checkboxes.forEach((checkbox) => {
        checkbox.checked = shouldCheck;
      });
    });
  });
});

