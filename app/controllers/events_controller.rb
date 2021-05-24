class EventsController < ApplicationController
  before_action :set_task_id, only: %i[show destroy]

  def index
    @user = User.find(current_user.id)
    events = @user.tasks.where(task_status: '未完了').where.not(client: @user.id)
    request_tasks = Task.where('(request_reply = ?) AND (contractor = ?)', '承諾', @user.id)
    if request_tasks.present?
      @events = Task.where(id: (events + request_tasks).map(&:id))
    else
      @events = events
    end
  end

  def show
  end

  def new
    @user = User.find(current_user.id)
    @event = @user.tasks.build
  end

  # def edit
  # end

  def create
    @user = User.find(current_user.id)
    @event = @user.tasks.build(event_params)
    @event.save
  end

  # def update
  #   @event.update(event_params)
  # end

  def destroy
    @event.destroy
  end

  private

  def event_params
    params.require(:task).permit(:title, :date_range, :start, :end_at, :color, :details, :client, :task_status, :progress)
  end
end
