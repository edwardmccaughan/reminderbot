class TaskManagerChannel < ApplicationCable::Channel
  def subscribed
    puts "[TaskManagerChannel] someone subscribed?"
    stream_from "global_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
