class DashboardController < ApplicationController
  before_action :login_required

  def index
    @from_admin = false
    if params[:id].present?
      @user = User.find(params[:id])
      @from_admin = true if params[:admin] == "1"
    else
      @user = current_user
    end

    @trainer = TrainerPlayer.find_by(user_id: @user.id)
    
    @trainings = UserRoutine.where("user_id = #{@user.id} and day != 7").count
    @trainings_complete = UserRoutine.where("user_id = #{@user.id} and done = 1 and day != 7").count
    @trainings_unfinished = UserRoutine.where("user_id = #{@user.id} and done = 0 and date >= '#{Date.today}'").count

    @training_width = ((@trainings_complete.to_f / @trainings.to_f) * 100).round
    @training_days_width = ((@trainings.to_f / @trainings_unfinished.to_f)).round
    @stage_width = (((@user.user_information.stage_process.to_f - 1) / @user.user_information.stage_count.to_f) * 100).round

    @last_entries = TestResult.where(user_id: current_user.id).order(id: :desc).limit(10)
  end

  def player_list
    players = TrainerPlayer.where(trainer_user_id: current_user.id)
    @array = []
    players.each do |player|
      user = User.find(player.user_id)
      @array.push(user) if user.present?
    end
  end

  def add_trainer_user
    user = User.find_by(email: params["search_param"])
    user_information = UserInformation.find_by(uid: params["search_param"])
    
    user_obj = ""
    if user.present?
      user_obj = user
    elsif user_information.present?
      user_obj = user_information.user
    end

    if user_obj == ""
      response =  { :error => true }
    else
      player_exists = TrainerPlayer.where(user_id: user_obj.id, trainer_user_id: current_user.id)
      if player_exists.present?
        response =  { :existe => true }
      else
        response = user_obj.to_json(:include => [:user_information])
        tp = TrainerPlayer.new
        tp.trainer_user_id = current_user.id
        tp.user_id = user_obj.id
        tp.save
      end
    end
    render json: response
  end

  def delete_trainer_user
    TrainerPlayer.where(trainer_user_id: current_user.id, user_id: params[:id]).destroy_all
    render plain: "OK"
  end

  def exercise_graph
    results = TestResult.where(user_id: current_user.id, exercise_id: params[:exercise_id]).order(id: :asc)
    render json: { :results => results }
  end

  def mailer_test
    AccountMailer.frase1("miguelbq88@gmail.com").deliver
    render plain: "OK"
  end
end
