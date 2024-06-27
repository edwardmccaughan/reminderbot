class ChatGtpAssistant
  # TODO: do I need to worry about creating too many of these while developing? ie: delete old ones?
  def create_assistant
    response = client.assistants.create(
      parameters: {
        model: "gpt-3.5-turbo-1106",
        name: "TODO list assistant", 
        description: nil,
        instructions: "You are a helpful assistant for keep track of todo list tasks",
        metadata: { my_internal_version_id: '1.0.0' },
        tools: ChatGtpFunctionsConfig.functions_for_assistant
      })
      puts "[CHATGTP create assistant] #{response}" 

      assistant_id = response["id"]
      Assistant.create(name: "todo assistant", assistant_id: assistant_id)
  end

  def create_thread
    response = client.threads.create
    current_assistant.update!(latest_thread: response["id"])
  end

  def client
    @client ||= OpenAI::Client.new
  end

  def current_assistant
    Assistant.last
  end

end