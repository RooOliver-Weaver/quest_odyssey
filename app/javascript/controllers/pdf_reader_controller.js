import { Controller } from "@hotwired/stimulus";
import * as pdfjsLib from "pdfjs-dist";

export default class extends Controller {
  static targets = ["name", "race", "speciality", "level", "background", "alignment", "strength", "dexterity", "constitution", "wisdom", "intelligence", "charisma"];

  connect() {
    console.log("PDF Reader Controller Connected!");

    // Manually set the worker source
    pdfjsLib.GlobalWorkerOptions.workerSrc = "https://cdn.jsdelivr.net/npm/pdfjs-dist@2.10.377/es5/build/pdf.worker.min.js";
  }

  loadPdf(event) {
    console.log("PDF upload triggered");
    const file = event.target.files[0];
    if (!file || !file.type.includes("pdf")) {
      alert("Please select a valid PDF.");
      return;
    }

    console.log("PDF file selected:", file);
    const reader = new FileReader();
    reader.onload = async () => {
      const typedarray = new Uint8Array(reader.result);
      const pdf = await pdfjsLib.getDocument({ data: typedarray }).promise;

      const page = await pdf.getPage(1);
      const textContent = await page.getTextContent();
      const extractedText = textContent.items.map((item) => item.str).join(" ");

      console.log("Extracted Text:", extractedText); // Check extracted text
      this.fillForm(extractedText);
    };

    reader.readAsArrayBuffer(file);
  }


  fillForm(text) {
    console.log("Filling form with extracted text:", text);

    this.nameTarget.value = "Test Name";

    const nameMatch = text.match(/Character Name\s*(\w+)/);
    if (nameMatch) this.nameTarget.value = nameMatch[1];

    const raceMatch = text.match(/Race\s*(\w+)/);
    if (raceMatch) this.raceTarget.value = raceMatch[1];

    const classLevelMatch = text.match(/Class & Level\s*([\w\s]+)\s*(\d+)/);
    if (classLevelMatch) {
      this.specialityTarget.value = classLevelMatch[1].trim();
      this.levelTarget.value = classLevelMatch[2];
    }

    this.extractStat(text, "Strength", this.strengthTarget);
    this.extractStat(text, "Dexterity", this.dexterityTarget);
    this.extractStat(text, "Constitution", this.constitutionTarget);
    this.extractStat(text, "Wisdom", this.wisdomTarget);
    this.extractStat(text, "Intelligence", this.intelligenceTarget);
    this.extractStat(text, "Charisma", this.charismaTarget);

    const backgroundMatch = text.match(/Background\s*(\w+)/);
    if (backgroundMatch) this.backgroundTarget.value = backgroundMatch[1];

    const alignmentMatch = text.match(/Alignment\s*(\w+)/);
    if (alignmentMatch) this.alignmentTarget.value = alignmentMatch[1];
  }

  extractStat(text, statName, targetElement) {
    const statMatch = text.match(new RegExp(`${statName}\\s*(\\d+)`));
    if (statMatch) targetElement.value = statMatch[1];
  }
}
