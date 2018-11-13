class Administrator::AdminController < ApplicationController
  before_action :check_if_admin
  layout "administrator"

  def list_users
    @user = User.joins(:user_information).where("user_type_id != 1")
  end

  def show_user
    @user = User.find(params[:id])
  end

  private
  def check_if_admin
    redirect_back(fallback_location: root_path) if current_user.user_information.user_type_id != 1
  end
end
