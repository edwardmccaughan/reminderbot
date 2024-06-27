class ChatGtpFunctionImplementations

  def self.list_tasks(function)
    Task.all.map do |task|
      "#{task.name} - #{task.status}"
    end.join("<br/>")
  end

  def self.add_task(function)
    time = Chronic.parse(function.args.time)
    if time
      task = Task.create!(name: function.args.task, due_date: time)
      "ok, I created a task to #{function.args.task} at #{task.due_date_formatted}"
    else
      # TODO: when the time is too fuzzy, chronic just returns nil
      "could you give a clearer time?"
    end
  end


  def self.update_task_status(function)   
    task = Task.find_by(name: function.args.task) || find_nearest_task(function.args.task)

    task.update!(status: function.args.status)
    
    "ok, I marked '#{task.name}' as #{function.args.status}"
  end

 def self.kick_off_session
    tasks_csv = Task.all.map do |task|
      "#{task.name}, #{task.status}, #{task.due_date_formatted}"      
    end.join("\n")

    "Here is my todo list, in something like a csv list where the format is 'task name', 'task status' and 'due date' \n" + tasks_csv
  end


  # TODO: I think I won't be able to do this without sending a response from the original tool?
  # def self.kick_off_session
  #   tasks_csv = Task.all.map do |task|
  #     "#{task.name}, #{task.status}, #{task.due_date_formatted}"      
  #   end.join("\n")

  #   prompt = "Here is my todo list, in something like a csv list where the format is 'task name', 'task status' and 'due date' \n" + tasks_csv
  #   ChatGtpAssistantmessage.new.send_message(prompt)
  #   "I loaded your existing tasks"
  # end

  # TODO: sometimes chatgtp reponse with "the matching task is xyz", or adds quotes which is not helpful
  def self.find_nearest_task(name)
    puts "trying to find a matching task with chatgtp"
    task_list = Task.all.map(&:name).join(',')
    message = "which task in this list (#{task_list}) is the closest match to '#{name}'? reply with just the name task from the list, without quote marks or punctuation"

    response = ChatGtpHelper.new.send_message(message)

    matching_task_name = response.dig("choices", 0, "message", "content")
    puts "[CHATGTP response] #{matching_task_name}"

    Task.find_by(name: matching_task_name)
  end

end