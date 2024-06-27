class Task < ApplicationRecord
  after_update_commit :broadcast_task_updated
  after_create_commit :broadcast_task_created

  def broadcast_task_updated
    # broadcast_update_to(:tasks)
    # it will use the task partial by default
    broadcast_replace_later_to :tasks, target: self, partial: 'tasks/task', locals: { task: self }
  end

  def broadcast_task_created
    broadcast_prepend_later_to :tasks, target: 'tasks_table', partial: 'tasks/task', locals: { task: self }
  end


  def due_date_formatted
    return "" if due_date.nil? # TODO: should everything have a due date?

    due_date.strftime('%Y-%m-%d %H-%M')
  end
end
