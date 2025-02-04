import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results", "campaign"];

  filter() {
    const query = this.inputTarget.value.toLowerCase();

    this.campaignTargets.forEach((campaign) => {
      const name = campaign.dataset.name;
      campaign.style.display = name.includes(query) ? "block" : "none";
    });
  }
}
