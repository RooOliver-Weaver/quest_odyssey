import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-pic-dropdown"
export default class extends Controller {
  static targets = ["dropdown"];

  connect() {
    console.log("Character pic controller connected")
  }

  toggleDropdown(event) {
    event.preventDefault();
    this.element.classList.toggle("is-visible");
    this.dropdownTarget.classList.add("show");
    console.log("Dropdown toggled, is open:", this.dropdownTarget.classList.contains("show"));
  }

  selectImage(event) {
    const selectedImage = event.target.dataset.image;
    console.log("Selected image:", selectedImage);  // Check which image was selected

    const input = document.getElementById("character-pic-input");
    console.log("Found input element:", input);  // Check if the input element is being correctly found
    const selectedImageElement = document.getElementById("selected-image");

    if (input) {
      input.value = selectedImage;  // Update hidden input
      console.log("Input value set to:", selectedImage);  // Confirm that the value is being set
    } else {
      console.error("Input element not found");  // If input is not found, log an error
    }

    if (selectedImageElement) {
      selectedImageElement.src = `<%= asset_path(selectedImage) %>`;
      console.log("updated image src", selectedImageElement.src);
    } else {
      console.log("selected image not found");
    }

    this.dropdownTarget.classList.remove("show");  // Close the dropdown
    console.log("Dropdown closed.");
  }
}
