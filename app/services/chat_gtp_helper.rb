class ChatGtpHelper

  # TODO: probably could be a singleton
  def send_message(message)
    puts "[CHATGTP] sending prompt: #{message}"
    client.chat(
      parameters: {
        model: "gpt-3.5-turbo-0613",
        messages: [
          {
            role: "user",
            content: message
          },
        ],
        # TODO: probably shouldn't send all the functions all the time
        functions: ChatGtpFunctionsConfig.functions_for_single_message
      },
    )
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

end