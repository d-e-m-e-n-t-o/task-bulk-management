class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :details
      t.integer :client, default: 0
      t.integer :contractor, default: 0
      t.string :task_status, null: false, default: '未完了'
      t.integer :progress, null: false, default: 0
      t.string :request_reply, default: '未返答'
      t.string :request_comment
      t.boolean :reply_confirm, default: 'false'
      t.date :start, null: false
      t.date :end_at, null: false
      t.string :color
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
