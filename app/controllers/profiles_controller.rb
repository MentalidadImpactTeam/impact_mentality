class ProfilesController < ApplicationController
  def index
    @card = UserConektaToken.find_by(user_id: current_user.id, default: 1)
    @trainings = UserRoutine.where(user_id: current_user.id).count
    @trainings_complete = UserRoutine.where("user_id = #{current_user.id} and done = 1 and day != 7").count

    @stage_width = (((current_user.user_information.stage_process.to_f - 1) / current_user.user_information.stage_count.to_f) * 100).round
    @age = TimeDifference.between(current_user.user_information.birth_date, Date.today).in_years.to_i
  end

  def update
    current_user.user_information.height = params[:height] if params[:height].present?
    current_user.user_information.weight = params[:weight] if params[:weight].present?
    current_user.user_information.phone  = params[:phone]  if params[:phone].present?
    current_user.user_information.save

    render plain: "OK"
  end

  def update_profile_image
    current_user.user_information.img_url = params[:img_url]
    current_user.user_information.save

    redirect_to profiles_path
  end
end
