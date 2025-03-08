document.addEventListener('turbo:load', initCarouselCheckboxHandler);
document.addEventListener('turbo:frame-load', initCarouselCheckboxHandler);
document.addEventListener('DOMContentLoaded', initCarouselCheckboxHandler);

function initCarouselCheckboxHandler() {
  const checkboxes = document.querySelectorAll('.carousel-checkbox');

  if (checkboxes.length === 0) return; // Exit if no checkboxes are found

  checkboxes.forEach(function (checkbox) {
    checkbox.removeEventListener('change', handleCheckboxChange); // Avoid duplicate event listeners
    checkbox.addEventListener('change', handleCheckboxChange);
  });
}

function handleCheckboxChange() {
  const checked = document.querySelectorAll('.carousel-checkbox:checked');

  if (checked.length > 7) {
    this.checked = false;
    alert('You can only select up to 7 articles for the carousel');
  }
}
