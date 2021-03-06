class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def login_required
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    resource.sign_in_count += 1
    resource.save
    
    if resource.user_information.user_type_id == 1
      administrator_users_path
    elsif resource.user_information.user_type_id == 2
      player_list_path
    elsif resource.user_information.user_type_id == 3
      dashboard_path
    end
  end
end
