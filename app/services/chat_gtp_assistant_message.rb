class ChatGtpAssistantMessage

  def send_message(message)
    client.messages.create(
      thread_id: current_thread_id,
      parameters: {
        role: "user",
        content: message,
    })

    response = client.runs.create(thread_id: current_thread_id,
      parameters: {
          assistant_id: current_assistant.assistant_id
      })

    get_response_message(response['id'], current_thread_id)   
  end


  def get_response_message(run_id, thread_id)
    status = "in_progress"
    while(status == "in_progress")
      response = client.runs.retrieve(id: run_id, thread_id: thread_id)
      status = response['status']
      sleep 0.1 # TODO: only sleep when no result and raise an error if we're in here more than a few loops 
    end

    puts "[CHATGTP][finished_run] #{response}"

    if status == "requires_action"
      handle_function_response(response, run_id)
    else
      # We're in a normal message reply
      handle_normal_message_response(thread_id, run_id)
    end    
  end


  private

  def handle_function_response(response, run_id)

    function_responses = response.dig("required_action","submit_tool_outputs","tool_calls")
    
    if function_responses.count > 1
      panic_and_close_all_tools(function_responses, run_id)
    end

    args = OpenStruct.new(JSON.parse(function_responses.first.dig("function","arguments")))

    function_object = OpenStruct.new(
      function_name: function_responses.first.dig("function","name"),
      args: args,
      tool_id: function_responses.first["id"]
    )


    puts ["[CHATGTP] running function: #{function_object.function_name}"]
    
    tool_output = case function_object.function_name
      when "kick_off_session"
        ChatGtpFunctionImplementations.kick_off_session
      when "add_task"
        ChatGtpFunctionImplementations.add_task(function_object)
      when "list_tasks"
        ChatGtpFunctionImplementations.list_tasks(function_object)
      when "update_task_status"
         ChatGtpFunctionImplementations.update_task_status(function_object)
      else
        # TODO: not sure this can really happen
         "invalid function: #{function_object.function_name}"
      end

    client.runs.submit_tool_outputs(
      thread_id: current_thread_id,
      run_id: run_id,
      parameters: {
        tool_outputs: [{
          tool_call_id: function_object.tool_id, output: tool_output
        }]
      }
    )

    tool_output # still need to reply with tool output so we display it
  end


  def panic_and_close_all_tools(function_responses, run_id)
    tool_outputs = function_responses.map do |function_response|
      { 
        tool_call_id: function_response["id"],
        output: "panic! too many tool responses"
      }
    end

    client.runs.submit_tool_outputs(
      thread_id: current_thread_id,
      run_id: run_id,
      parameters: {
        tool_outputs: tool_outputs
      }
    )

    "somehow that turned into multiple tool responses, which I don't handle right now [#{function_responses}]"
  end


  def handle_normal_message_response(thread_id, run_id)
    run_steps = client.run_steps.list(thread_id: thread_id, run_id: run_id)
    new_message_ids = run_steps['data'].filter_map { |step|
      if step['type'] == 'message_creation'
        step.dig('step_details', "message_creation", "message_id")
      end # Ignore tool calls, because they don't create new messages.
    }

    # Retrieve the individual messages
    new_messages = new_message_ids.map { |msg_id|
      client.messages.retrieve(id: msg_id, thread_id: thread_id)
    }

    puts "[CHATGTP][new_messages] #{new_messages}"
    raise "no support for multiple responses yet" if new_messages.count > 1
    if new_messages.first["content"].count > 1
      "got multiple responses: #{new_messages.first['content']}"
    else
      new_messages.first["content"].first["text"]["value"]  
    end
  end


  def client
    @client ||= OpenAI::Client.new
  end

  def current_assistant
    Assistant.last
  end

  def current_thread_id
    @current_thread_id ||= current_assistant.latest_thread
  end
end