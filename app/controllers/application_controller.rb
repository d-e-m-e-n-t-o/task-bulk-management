class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # CSRF対策
  include SessionsHelper # SessionsHelper内のメソッドを使用

  before_action :authenticate_user! # ログイン済ユーザーのみにアクセスを許可
  before_action :configure_permitted_parameters, if: :devise_controller? # deviseコントローラーにストロングパラメータを追加

  protected
  # ストロングパラメーター追加メソッド
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :position]) # サインアップ時にname、email、positionのストロングパラメータを追加
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :position]) # アカウント編集の時にname、email、positionのストロングパラメータを追加
  end

  private

  # idより@userを定義
  def set_user
    @user = params[:id].nil? ? User.new : User.find(params[:id])
  end

  # user_idより@userを定義
  def set_user_user_id
    @user = User.find(params[:user_id])
  end

  # idより@taskを定義
  def set_task_id
    @task = Task.find(params[:id])
  end

  # idより@userを定義
  def set_user_id
    @user = User.find(params[:id])
  end
end
