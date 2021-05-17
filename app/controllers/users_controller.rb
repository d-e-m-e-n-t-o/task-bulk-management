class UsersController < ApplicationController
  before_action :set_user_id, only: %i[edit update destroy]

  def index
    @users =
      if params[:search].present?
        User.where('name LIKE ?', "%#{params[:search]}%").page(params[:page]).per(10)
      else
        User.page(params[:page]).per(10)
      end
  end

  def edit
  end

  def update
    if @user.update(users_update_params)
      flash[:notice] = 'アカウント情報を更新しました。'
    else
      flash[:alert] = 'アカウント情報の更新に失敗しました。'
    end
    redirect_to users_path
  end

  def destroy
    @user.destroy
    flash[:notice] = "#{@user.name}のアカウント情報を削除しました。"
    redirect_to users_path
  end

  private

  def users_update_params
    params.require(:user).permit(:name, :email, :position, :admin)
  end
end
