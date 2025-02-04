document.addEventListener("DOMContentLoaded", function() {
  const dayButtons = document.querySelectorAll('.day-button');

  dayButtons.forEach(button => {
    button.addEventListener('click', function() {
      const day = this.getAttribute('data-day');
      const slotsDiv = document.getElementById(`${day}_slots`);

      // Toggle the visibility of the slots
      if (slotsDiv.style.display === 'none' || !slotsDiv.style.display) {
        slotsDiv.style.display = 'block';
      } else {
        slotsDiv.style.display = 'none';
      }
    });
  });
});
