import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "list" ]

  append(html){
    // TODO: this is totally the wrong way of doing this, probably turbo is more sensible
    this.listTarget.insertAdjacentHTML('beforeend', html.detail)
  }

}
