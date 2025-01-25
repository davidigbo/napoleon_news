import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    console.log("Flash Notifications Controller Connected");
    this.autoDismissFlashMessages();
  }

  autoDismissFlashMessages() {
    const flashMessages = document.querySelectorAll('.alert');
    flashMessages.forEach((message) => {
      setTimeout(() => {
        message.classList.remove('show');
        message.classList.add('fade'); // Ensure fade class is added after removing show
      }, 1000); // 1 second for auto-dismissal, adjust as needed

      setTimeout(() => {
        message.remove(); // Completely remove the element after fade out
      }, 2000); // Wait for the fade transition before removing the element
    });
  }
}
