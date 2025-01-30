import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-scroll"
export default class extends Controller {
  static targets = ["messages"];

  connect() {
    this.scrollToBottom();

    document.addEventListener('turbo:before-stream-render', this.scrollToBottom.bind(this));
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }
}
