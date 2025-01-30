import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-scroll"
export default class extends Controller {
  static targets = ["messages"];

  connect() {
    this.scrollToBottom();

    console.log("Connected to chat-scroll controller");

    const currentUserId = parseInt(document.body.dataset.currentUserId, 10);
    if (this.userIdValue === currentUserId) {
      this.element.classList.add('sent');
      this.element.classList.remove('received');
    } else {
      this.element.classList.add('received');
      this.element.classList.remove('sent');
    }
    this.scrollToBottom();
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
    console.log("Scrolled to bottom");
  }

  newMessageAppeared() {
    this.scrollToBottom();
    console.log("New message appeared");
  }
}
