date_format = event.all_day_event? ? '%Y-%m-%d' : '%Y-%m-%d'

json.id event.id
json.title event.title
json.details event.details
json.client event.client
json.task_status event.task_status
json.progress event.progress
json.start event.start.strftime(date_format)
json.end event.end.strftime(date_format)
json.color event.color unless event.color.blank?
# json.allDay event.all_day_event? ? true : false
# json.update_url event_path(event, method: :patch)
# json.edit_url edit_event_path(event)
