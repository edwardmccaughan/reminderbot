import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "body" ]


  clear() {
    // TODO: this should probably be linked to the after submit action somehow?
        
    setTimeout(() => {
      this.bodyTarget.value = ""
    }, "100");
  }
}
