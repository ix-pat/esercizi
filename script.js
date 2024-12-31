document.addEventListener("DOMContentLoaded", function() {
  let isDisplayed = false; // Stato iniziale: soluzioni nascoste

  function toggleDisplay() {
    const elements = document.querySelectorAll('.sol');
    elements.forEach(element => {
      element.style.display = isDisplayed ? 'none' : 'block'; // Cambia lo stato di visualizzazione
    });
    isDisplayed = !isDisplayed; // Inverte lo stato
  }

  document.getElementById('toggleDisplay').addEventListener('click', toggleDisplay);
});
