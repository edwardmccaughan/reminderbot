import consumer from "channels/consumer"

consumer.subscriptions.create("TaskManagerChannel", {
  connected() {
    console.log("connected to task manager")
  },

  disconnected() {
    console.log("disconnected from task manager")
  },

  received(data) {
    console.log("received task manager", data)

    // TODO: this is a strange and messy way of doing this, I just wanted to try out mixing actioncable and stimulus
    const new_message = new CustomEvent("message", { detail: data.html });
    window.dispatchEvent(new_message);  
  }
});

