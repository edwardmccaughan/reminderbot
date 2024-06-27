class ChatGtpFunctionsConfig

  def self.add_task
    {
      name: "add_task",
      description: "add a task to the todo list.",
      parameters: {
        type: :object,
        properties: {
          task: {
            type: :string,
            description: "the task that I want to be reminded of",
          },
          time: {
            type: :string,
            description: "the time to remind me about the task, eg: tomorrow, or 5pm, or january 31st"
          }
        },
        required: ["task", "time"],
      }
    }
  end


  def self.update_task_status
    {
      name: "update_task_status",
      description: "update the status of a task on the todo list, eg: 'I finished the tax return' or 'I started doing the dishes'",
      parameters: {
        type: :object,
        properties: {
          task: {
            type: :string,
            description: "the existing task that I want to update",
          },
          status: {
            type: :string,
            description: "new status of the task, eg: completed, in progress, started",
            enum: %w[not_started started complete],
          }
        },
        required: ["task", "status"],
      }
    }
  end

  def self.kick_off_session
    {
      name: "kick_off_session",
      # description: "load my existing tasks, in a csv format and remember the task name, due date and status so I can ask you about it later",
      description: "kick off a new session",
    }
  end

  # TODO: does this make any sense anymore now that load_existing_tasks works?
  # { 
  #   name: "list_tasks",
  #   description: "tell me all the tasks",
  # },


  def self.functions_for_single_message
    [ add_task, update_task_status, kick_off_session ]
  end

  def self.functions_for_assistant
    [
      {
        type: "function",
        function: add_task
      },{
        type: "function",
        function: update_task_status
      },{
        type: "function",
        function: kick_off_session
      }
    ]
  end

end