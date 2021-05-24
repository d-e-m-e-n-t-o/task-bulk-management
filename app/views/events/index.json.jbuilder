json.array! @events do |event|
  date_format = '%Y-%m-%d'
  json.id event.id
  json.title event.title
  json.details event.details
  json.client event.client
  json.task_status event.task_status
  json.progress event.progress
  json.start event.start.strftime(date_format)
  json.end event.end_at.strftime(date_format)
  json.color event.color unless event.color.blank?
  # json.allDay event.all_day_event? ? true : false
  # json.update_url event_path(event, method: :patch)
  # json.edit_url edit_event_path(event)
  # unless event.color.blank?
  #   if event.color == '赤'
  #     json.color "#ff0000"
  #   elsif event.color == '青'
  #     json.color "#ff0000"
  #   elsif event.color == '黄'
  #     json.color "#ff0000"
  #   end
  # end
end
