class TasksRequestController < ApplicationController
  before_action :set_user_user_id, only: %i[index create new edit show update destroy tasks_request_all_history tasks_request_reply update_tasks_request_reply tasks_request_reply_confirm]
  before_action :set_task_id, only: %i[edit show update destroy]

  # 依頼済タスク一覧(依頼確認編集用)
  def index
    @tasks =
      if params[:search].present?
        Task.where('name LIKE ?', "%#{params[:search]}%").where(client: @user.id).where(task_status: '未完了').order("end_at").page(params[:page]).per(10)
      else
        Task.where(client: @user.id).page(params[:page]).order("end_at").per(10)
      end
  end

  def create
    @task = @user.tasks.build(tasks_request_create_params)
    if @task.save
      flash[:notice] = 'タスクを新規依頼しました。'
    else
      flash[:alert] = 'タスクの新規依頼に失敗しました。'
    end
    redirect_to user_tasks_request_index_path(@user.id)
  end

  def new
    @task = Task.new
    @users = User.all.where.not(id: current_user.id)
  end

  def edit
    @btn_status = params[:btn_status]
    @users = User.all.where.not(id: current_user.id)
  end

  def show
    @contractor = User.find(@task.contractor)
  end

  def update
    if current_user.id != @task.user_id
      @task.destroy
      if current_user.tasks.create(tasks_request_update_params)
        flash[:notice] = 'タスクを新規依頼しました。'
      else
        flash[:alert] = 'タスクの新規依頼に失敗しました。'
      end
    end
    if current_user.id == @task.user_id
      if @task.update(tasks_request_update_params)
        flash[:notice] = '依頼中のタスク情報を更新しました。'
      else
        flash[:alert] = '依頼中のタスク情報更新に失敗しました。'
      end
    end
    redirect_to user_tasks_request_index_path(@user.id)
  end

  def destroy
    @task.destroy
    flash[:notice] = "#{@task.title}のタスクデータを削除しました。"
    redirect_to user_tasks_request_index_path(@user.id)
  end

  # タスク履歴一覧(タスク依頼用)
  def tasks_request_all_history
    @tasks =
      if params[:search].present?
        Task.where('title LIKE ?', "%#{params[:search]}%").where(task_status: '完了').page(params[:page]).per(10)
      else
        Task.where(task_status: '完了').page(params[:page]).per(10)
      end
  end

  # 依頼されたタスク表示用
  def tasks_request_reply
    @request_tasks = Task.where('(request_reply = ?) AND (contractor = ?)', '未返答', @user.id).order("end_at")
  end

  # 依頼されたタスクに対しての返信用
  def update_tasks_request_reply
    update_tasks_request_reply_params.each do |id, item|
      task = Task.find(id)
      if task.update(item)
        flash[:notice] = '依頼されたタスクに返信しました。'
      else
        flash[:alert] = '依頼されたタスクの返信に失敗しました。'
      end
    end
    redirect_to user_tasks_path(@user.id)
  end

  # 依頼したタスクに対しての返信確認用
  def tasks_request_reply_confirm
    @reply_tasks = @user.tasks.where(reply_confirm: false).where('(request_reply = ?) OR (request_reply = ?)', '承諾', '拒否').order("end_at")
    @reply_tasks.update(reply_confirm: true)
  end


  private

  def tasks_request_create_params
    params.require(:task).permit(:title, :details, :client, :contractor, :task_status, :progress, :request_reply, :start, :end_at)
  end

  def tasks_request_update_params
    params.require(:task).permit(:title, :details, :client, :contractor, :task_status, :progress, :request_reply, :start, :end_at, :request_comment)
  end

  def update_tasks_request_reply_params
    params.permit(request_tasks: %i[request_reply request_comment reply_confirm])[:request_tasks]
  end
end
