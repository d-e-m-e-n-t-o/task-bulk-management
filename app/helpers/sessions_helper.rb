module SessionsHelper
# ユーザーがログイン済みのユーザーであればtrueを返す。
  def current_user?(user)
    user == current_user
  end
end
