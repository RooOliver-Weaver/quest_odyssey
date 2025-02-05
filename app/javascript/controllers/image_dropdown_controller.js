import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="campaign-pic-dropdown"
export default class extends Controller {
  static targets = ["dropdown", "preview"]

  connect() {
    console.log("📌 Campaign pic controller connected");
  }

  toggleDropdown(event) {
    event.preventDefault();

    if (!this.hasDropdownTarget) {
      console.error("❌ Dropdown target not found!");
      return;
    }

    this.dropdownTarget.classList.toggle("is-visible");
    console.log("📌 Dropdown toggled, is open:", this.dropdownTarget.classList.contains("is-visible"));
  }

  selectImage(event) {
    const selectedImage = event.target.dataset.image;  // Get image URL
    console.log("✅ Selected campaign image:", selectedImage);

    const input = document.getElementById("campaign-pic-input");
    const selectedImageElement = this.previewTarget;  // Target preview image

    if (input) {
      input.value = selectedImage;
      console.log("🔄 Input value updated:", input.value);
    } else {
      console.error("❌ Campaign input element not found!");
    }

    if (selectedImageElement) {
      selectedImageElement.src = selectedImage;
      console.log("🖼️ Campaign image preview updated:", selectedImageElement.src);
    } else {
      console.error("❌ Campaign preview image not found!");
    }

    this.dropdownTarget.classList.remove("is-visible");  // Close dropdown
    console.log("📌 Dropdown closed.");
  }
}
