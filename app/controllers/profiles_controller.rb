class ProfilesController < ApplicationController
  def index
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @card = UserConektaToken.find_by(user_id: @user.id, default: 1)
    @trainings = UserRoutine.where(user_id: @user.id).count
    @trainings_complete = UserRoutine.where("user_id = #{@user.id} and done = 1 and day != 7").count

    @stage_width = (((@user.user_information.stage_process.to_f - 1) / @user.user_information.stage_count.to_f) * 100).round
    if @user.user_information.birth_date.present?
      @age = TimeDifference.between(@user.user_information.birth_date, Date.today).in_years.to_i
    else
      @age = 0
    end
  end

  def show
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @card = UserConektaToken.find_by(user_id: @user.id, default: 1)
    @trainings = UserRoutine.where(user_id: @user.id).count
    @trainings_complete = UserRoutine.where("user_id = #{@user.id} and done = 1 and day != 7").count

    @stage_width = (((@user.user_information.stage_process.to_f - 1) / @user.user_information.stage_count.to_f) * 100).round
    if @user.user_information.birth_date.present?
      @age = TimeDifference.between(@user.user_information.birth_date, Date.today).in_years.to_i
    else
      @age = 0
    end
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
