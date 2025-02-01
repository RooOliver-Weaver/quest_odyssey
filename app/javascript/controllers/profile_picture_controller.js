import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile-picture"
export default class extends Controller {
  static targets = ["dropdown", "preview"]

  connect() {
    this.dropdownVisible = false;
  }

  toggleDropdown() {
    this.dropdownVisible = !this.dropdownVisible;
    if (this.dropdownVisible) {
      this.element.classList.add("open");
    } else {
      this.element.classList.remove("open");
    }
  }

  selectImage(event) {
    const selectedImage = event.target.dataset.value;
    const previewImage = this.previewTarget;

    // Update the image source with the selected image
    previewImage.src = selectedImage;
    this.dropdownVisible = false; // Close the dropdown
    this.element.classList.remove("open");
  }
}
