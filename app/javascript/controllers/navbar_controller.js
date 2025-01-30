import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "navbar", "home", "characters", "campaigns", "calendar" ];

  connect() {
    this.setActiveOnPageLoad();
    console.log("Navbar controller connected");
    console.log("Home Target: ", this.homeTarget);
    console.log("Characters Target: ", this.charactersTarget);
    console.log("Campaigns Target: ", this.campaignsTarget);
    console.log("Calendar Target: ", this.calendarTarget);
    console.log("Navbar Target: ", this.navbarTarget);
  }

  toggle(event) {
    event.preventDefault();
    this.navbarTarget.classList.toggle("open");
  }

  setActive(event) {
    this.homeTarget.classList.remove("active");
    this.charactersTarget.classList.remove("active");
    this.campaignsTarget.classList.remove("active");
    this.calendarTarget.classList.remove("active");

    event.target.closest('a').classList.add("active");
  }

  setActiveOnPageLoad() {
    const path = window.location.pathname;

    if (path === "/") {
      this.homeTarget.classList.add("active");
    } else if (path === "/characters") {
      this.charactersTarget.classList.add("active");
    } else if (path === "/campaigns") {
      this.campaignsTarget.classList.add("active");
    } else if (path === "/calendar") {
      this.calendarTarget.classList.add("active");
    }
  }
}
