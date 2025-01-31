import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-scroll"
export default class extends Controller {
  static targets = ["messages"];

  connect() {
    this.scrollToBottom();

    document.addEventListener('turbo:before-stream-render', this.scrollToBottom.bind(this));

    document.addEventListener('turbo:render', this.scrollToBottom.bind(this));

    window.addEventListener("chatbox:opened", this.reconnect.bind(this));
  }

  scrollToBottom() {
    setTimeout(() => {
      if (this.messagesTarget) {
        this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
      }
    }, 0);
  }

  reconnect() {
    this.scrollToBottom();
    document.addEventListener('turbo:before-stream-render', this.scrollToBottom.bind(this));
    document.addEventListener('turbo:render', this.scrollToBottom.bind(this));
  }
}
