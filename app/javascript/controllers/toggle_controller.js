import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['form']

  connect() {
    console.log("Hello from toggle controller");
  }

  toggle() {
    console.log("clicked")
    this.formTarget.classList.toggle('d-none')

  }
}
