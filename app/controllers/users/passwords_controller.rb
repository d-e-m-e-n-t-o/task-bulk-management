# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
before_action :set_user, only: %i[new]

  # GET /resource/password/new
  def new
  end

  # POST /resource/password
  def create
    if params["user"]["email"].blank?
      redirect_to root_path, alert: 'メールアドレスが未入力です。'
    else
      super
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # //////////////////////////////
  def resource_name
    :user
  end

  def resource
    @resource = @user
  end

  # def devise_mapping
  #   @devise_mapping ||= Devise.mappings[:user]
  # end
end
