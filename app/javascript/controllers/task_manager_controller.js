import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // console.log("running scheduler")
    // setInterval(() => {
    //   fetch("http://localhost:3000/task_manager_scheduler")
    // }, 5000);
  }

  run(){
    console.log("running scheduler")
    fetch("http://localhost:3000/task_manager_scheduler")
  }
}
