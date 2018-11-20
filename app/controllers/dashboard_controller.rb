class DashboardController < ApplicationController
  before_action :login_required

  def index
    @trainings = UserRoutine.where("user_id = #{current_user.id} and day != 7").count
    @trainings_complete = UserRoutine.where("user_id = #{current_user.id} and done = 1 and day != 7").count
    @trainings_unfinished = UserRoutine.where("user_id = #{current_user.id} and done = 0 and date >= '#{Date.today}'").count

    @training_width = ((@trainings_complete.to_f / @trainings.to_f) * 100).round
    @stage_width = (((current_user.user_information.stage_process.to_f - 1) / current_user.user_information.stage_count.to_f) * 100).round
  end
end
