class TasksController < ApplicationController
  before_action :set_user_user_id, only: %i[index new create edit show tasks_all_history update_tasks_request tasks_all_incomplete]
  before_action :set_task_id, only: %i[edit show update destroy]

  #タスク一覧(押下ボタン毎でタスクを取得)
  def index
    if params[:btn_status] == 'completed'
      @btn_status = 'completed'
      tasks = @user.tasks.where(task_status: '完了')
      request_tasks = Task.where('(request_reply = ?) AND (contractor = ?) AND (task_status = ?)', '承諾', @user.id, '完了')
      if request_tasks.present?
        @tasks = Task.where(id: (tasks + request_tasks).map(&:id)).order("end DESC").page(params[:page]).per(10)
      else
        @tasks = tasks.order("end DESC").page(params[:page]).per(10)
      end
    else
      @btn_status = 'incomplete'
      tasks = @user.tasks.where(task_status: '未完了').where.not(client: @user.id)
      request_tasks = Task.where('(request_reply = ?) AND (contractor = ?) AND (task_status = ?)', '承諾', @user.id, '未完了')
      tasks_id = (tasks + request_tasks).map(&:id)
      if tasks.present? || request_tasks.present?
        @tasks = Task.where(id: tasks_id).page(params[:page]).per(5)
      elsif tasks.present?
        @tasks = tasks.order("end").page(params[:page]).per(5)
      else
        @tasks = tasks
      end

      # tasks = @user.tasks.where(task_status: '未完了').where.not(client: @user.id)
      # request_tasks = Task.where('(request_reply = ?) AND (contractor = ?) AND (task_status = ?)', '承諾', @user.id, '未完了')
      # if request_tasks.present?
      #   @tasks = Task.where(id: (tasks + request_tasks).map(&:id)).order("end").page(params[:page]).per(5)
      # else
      #   @tasks = tasks.order("end").page(params[:page]).per(5)
      # end
    end
    @request_tasks = Task.where('(request_reply = ?) AND (contractor = ?)', '未返答', @user.id) # タスク依頼アラート
    @reply_tasks = @user.tasks.where(reply_confirm: false).where('(request_reply = ?) OR (request_reply = ?)', '承諾', '拒否') # タスク返信アラート
  end

  def new
    @task = Task.new
  end

  def create
    @task = @user.tasks.build(tasks_create_params)
    if @task.save
      flash[:notice] = 'タスクを新規登録しました。'
    else
      flash[:alert] = 'タスクの新規登録に失敗しました。'
    end
    redirect_to user_tasks_path(@user)
  end

  def edit
    @btn_status = params[:btn_status]
    @users = User.all.where.not(id: @user.id)
  end

  def show
    if (@task.client != 0) && (@task.user_id != @user.id)
      @client = User.find(@task.client)
    elsif (@task.client != 0) && (@task.user_id == @user.id)
      @contractor = User.find(@task.contractor)
    end
  end

  def update
    if (current_user.id != @task.user_id) && (current_user.id != @task.contractor)
      @task.destroy
      if current_user.tasks.create(tasks_update_params)
        flash[:notice] = 'タスクを新規登録しました。'
      else
        flash[:alert] = 'タスクの新規登録に失敗しました。'
      end
    end
    if (current_user.id == @task.user_id) || (current_user.id == @task.contractor)
      if @task.update(tasks_update_params)
        flash[:notice] = 'タスク情報を更新しました。'
      else
        flash[:alert] = 'タスク情報の更新に失敗しました。'
      end
    end
    redirect_to user_tasks_path(current_user.id)
  end

  def destroy
    @task.destroy
    flash[:notice] = "#{@task.title}のタスクデータを削除しました。"
    redirect_to user_tasks_path(@task.user_id)
  end

  # タスク履歴一覧(タスク再登録用)
  def tasks_all_history
    @tasks =
      if params[:search].present?
        Task.where('name LIKE ?', "%#{params[:search]}%").where(task_status: '完了').order("user_id").page(params[:page]).per(10)
      else
        Task.where(task_status: '完了').page(params[:page]).order("user_id").per(10)
      end
  end

  def tasks_all_incomplete
    @tasks =
      if params[:search].present?
        Task.where('name LIKE ?', "%#{params[:search]}%").where(task_status: '未完了').where.not('(request_reply = ?) OR (request_reply = ?)', '未返信', '拒否').order("end").page(params[:page]).per(10)
      else
        Task.where(task_status: '未完了').where.not('(request_reply = ?) OR (request_reply = ?)', '未返信', '拒否').order("end").page(params[:page]).per(10)
      end
  end

  private

  def tasks_create_params
    params.require(:task).permit(:title, :details, :task_status, :progress, :start, :end)
  end

  def tasks_update_params
    params.require(:task).permit(:title, :details, :task_status, :progress, :start, :end)
  end
end
