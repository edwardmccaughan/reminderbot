class DebugController < ApplicationController

  def delete_tasks
    Task.destroy_all
    redirect_to messages_path
  end

  def delete_messages
    Message.destroy_all
    redirect_to messages_path
  end

  def new_thread
    ChatGtpAssistant.new.create_thread
    redirect_to messages_path
  end

end
