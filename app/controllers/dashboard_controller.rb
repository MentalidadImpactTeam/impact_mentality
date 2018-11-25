class DashboardController < ApplicationController
  before_action :login_required

  def index
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @trainings = UserRoutine.where("user_id = #{@user.id} and day != 7").count
    @trainings_complete = UserRoutine.where("user_id = #{@user.id} and done = 1 and day != 7").count
    @trainings_unfinished = UserRoutine.where("user_id = #{@user.id} and done = 0 and date >= '#{Date.today}'").count

    @training_width = ((@trainings_complete.to_f / @trainings.to_f) * 100).round
    @training_days_width = ((@trainings.to_f / @trainings_unfinished.to_f)).round
    @stage_width = (((@user.user_information.stage_process.to_f - 1) / @user.user_information.stage_count.to_f) * 100).round
  end

  def player_list
    players = TrainerPlayer.where(trainer_user_id: current_user.id)
    @array = []
    players.each do |player|
      user = User.find(player.user_id)
      @array.push(user) if user.present?
    end
  end

  def delete_trainer_user
    TrainerPlayer.where(trainer_user_id: current_user.id, user_id: params[:id]).destroy_all
    render plain: "OK"
  end
end
