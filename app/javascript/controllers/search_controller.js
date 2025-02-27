import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  
  connect() {
    // Debounce setup
    this.timeout = null
    
    // Add click outside listener
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }
  
  disconnect() {
    // Clean up listener
    document.removeEventListener('click', this.handleClickOutside.bind(this))
  }
  
  submit() {
    clearTimeout(this.timeout)
    
    this.timeout = setTimeout(() => {
      // Only submit if there's actual content to search for
      if (this.inputTarget.value.length > 2) {
        this.element.requestSubmit()
      }
    }, 500) // Wait 500ms after user stops typing
  }
  
  handleClickOutside(event) {
    // Hide results if clicking outside the search container
    if (!this.element.contains(event.target)) {
      const resultsFrame = document.getElementById('search-results')
      if (resultsFrame) {
        resultsFrame.innerHTML = ''
      }
    }
  }
}