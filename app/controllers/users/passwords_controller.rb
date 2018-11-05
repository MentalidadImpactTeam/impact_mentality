# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  layout "devise"
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    @user = current_user
    response = @user.update_with_password(user_params)
    if response
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      render plain: "true"
    else
      if user_params["password"] == user_params["password_confirmation"]
        render plain: "incorrect_password"
      else
        render plain: "difference_password"
      end
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
