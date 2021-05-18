# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# coding: utf-8

# 管理者登録
User.create!(name: '管理者A',
             email: 'sample-1@gmail.com',
             position: '店舗責任者',
             password: 'password',
             password_confirmation: 'password',
             admin: true)

User.create!(name: '管理者B',
             email: 'sample-2@gmail.com',
             position: 'マネージャー',
             password: 'password',
             password_confirmation: 'password',
             admin: true)

# 一般社員登録
(2..19).each do |n|
  name  = Gimei.name.kanji
  email = "sample-#{n + 1}@gmail.com"
  position = '一般社員'
  password = 'password'
  User.create!(name: name,
               email: email,
               position: position,
               password: password,
               password_confirmation: password)
end

#タスク登録
t = 0
d = 0
start = Date.current
progress = 0
users = User.all
users.each do |user|
  10.times do
    title = "タスク#{t += 1}"
    details = "詳細#{d += 1}"
    start += 3
    finish = start + 3
    progress += 50
    progress = progress == 150 ? 0 : progress
    task_status = progress == 100 ? '完了' : '未完了'
    user.tasks.create!(title: title,
                       details: details,
                       start: start,
                       end: finish,
                       task_status: task_status,
                       progress: progress)
  end
end

#依頼タスク登録
t = 0
d = 0
r = 0
start = Date.current
progress = 0
contractor = 1
user = User.find(1)
5.times do
  title = "タスク依頼#{t += 1}"
  details = "詳細依頼#{d += 1}"
  start += 3
  finish = start + 3
  progress = 0
  task_status = '未完了'
  contractor += 1
  case t
  when 1, 4
    request_reply = '承諾'
  when 2, 5
    request_reply = '拒否'
  else
    request_reply = '未返答'
  end

  # if t == 1
  #   request_reply = '承諾'
  # elsif t == 2
  #   request_reply = '拒否'
  # elsif t == 3
  #   request_reply = '未返答'
  # elsif t == 4
  #   request_reply = '承諾'
  # elsif t == 5
  #   request_reply = '拒否'
  # end

  reply_confirm = true if %w[承諾 拒否].include?(request_reply)
  request_comment = "タスク依頼コメント#{r += 1}"
  user.tasks.create!(title: title,
                     details: details,
                     start: start,
                     end: finish,
                     task_status: task_status,
                     progress: progress,
                     client: user.id,
                     contractor: contractor,
                     request_reply: request_reply,
                     reply_confirm: reply_confirm,
                     request_comment: request_comment)
end
