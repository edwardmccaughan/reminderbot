class ChatGtpThinker

  def initialize
  end

  def reminder_test(message)
    response = ChatGtpHelper.new.send_message(message)

    message = response.dig("choices", 0, "message")
    puts "[CHATGTP] #{message}"

    if message["role"] == "assistant" && message["function_call"]
      function = parse_function_response(message)

      case function.function_name
      when "kick_off_session"
        ChatGtpFunctionImplementations.kick_off_session
      when "add_task"
        ChatGtpFunctionImplementations.add_task(function)
      when "list_tasks"
        ChatGtpFunctionImplementations.list_tasks(function)
      when "update_task_status"
        ChatGtpFunctionImplementations.update_task_status(function)
      else
        # TODO: not sure this can really happen
        "invalid function: #{function.function_name}"
      end
    else
      "[not a task] #{message['content']}"
    end
  end

  private

  def parse_function_response(message)
    args = JSON.parse(
        message.dig("function_call", "arguments"),
        { symbolize_names: true },
      )

    OpenStruct.new(
      function_name: message.dig("function_call", "name"),
      args: OpenStruct.new(args)
    )
  end

end