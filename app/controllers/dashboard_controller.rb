class DashboardController < ApplicationController
  before_action :login_required

  def index
    @trainings = UserRoutine.where(user_id: current_user.id).count
    @trainings_complete = UserRoutine.where(user_id: current_user.id, done: 1).count
    @trainings_unfinished = UserRoutine.where("user_id = #{current_user.id} and done = 0 and date >= '#{Date.today}'").count
  end
end
