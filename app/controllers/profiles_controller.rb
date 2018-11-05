class ProfilesController < ApplicationController
  def index
    @card = UserConektaToken.find_by(user_id: current_user.id, default: 1)
    @trainings = UserRoutine.where(user_id: current_user.id).count
    @trainings_complete = UserRoutine.where(user_id: current_user.id, done: 1).count
  end

  def update
    current_user.user_information.height = params[:height] if params[:height].present?
    current_user.user_information.weight = params[:weight] if params[:weight].present?
    current_user.user_information.phone  = params[:phone]  if params[:phone].present?
    current_user.user_information.save

    render plain: "OK"
  end
end
