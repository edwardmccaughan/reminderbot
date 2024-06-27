class CreateAssistants < ActiveRecord::Migration[7.1]
  def change
    create_table :assistants do |t|
      t.string :name
      t.string :assistant_id
      t.string :latest_thread

      t.timestamps
    end
  end
end
