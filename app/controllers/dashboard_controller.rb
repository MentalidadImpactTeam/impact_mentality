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
    @stage_width = (((@user.user_information.stage_process.to_f - 1) / @user.user_information.stage_count.to_f) * 100).round
    past_days = (@trainings - @trainings_unfinished) * 100
    @training_days_width = (past_days / @trainings.to_f).round

    @last_entries = TestResult.where(user_id: current_user.id).order(id: :desc).limit(10)
  end

  def player_list
    players = TrainerPlayer.where(trainer_user_id: current_user.id).limit(10).offset(0)
    @array = []
    players.each do |player|
      user = User.find(player.user_id)
      @array.push(user) if user.present?
    end

    @count_min =  @array.length > 10 ? 10 : @array.length
    @count_max =  TrainerPlayer.where(trainer_user_id: current_user.id).count
  end

  def add_trainer_user
    if current_user.active == 0
      response =  { :error => true, :mensaje => "No tiene su cuenta activa, favor de comunicarse con soporte." }
    else
      user = User.find_by(email: params["search_param"])
      user_information = UserInformation.find_by(uid: params["search_param"])
      
      user_obj = ""
      if user.present?
        user_obj = user
      elsif user_information.present?
        user_obj = user_information.user
      end
  
      if user_obj == ""
        response =  { :error => true, :mensaje => "No se encontro el jugador ingresado." }
      else
        player_exists = TrainerPlayer.where(user_id: user_obj.id)
        if player_exists.present?
          if user_obj.user_information.user_type_id == 2
            response =  { :error => true, :mensaje => "No se puede agregar un entrenador como jugador." }
          else
            response =  { :existe => true }
          end
        else
          user_ids = TrainerPlayer.select(:user_id).where(trainer_user_id: current_user.id)
          player_count = user_ids.count
          
          if (player_count + 1) > current_user.user_information.player_plan
            response =  { :error => true, :mensaje => "Ya estan ingresados el numero maximo de jugadores de su plan." }
          else
            response = user_obj.to_json(:include => [:user_information])
            tp = TrainerPlayer.new
            tp.trainer_user_id = current_user.id
            tp.user_id = user_obj.id
            tp.save
          end
        end
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

  def search_trainer_users
    response = { :error => true, :users => [], :max => 0 }
    user_ids = []
    users = User.where("email like '%#{params[:search]}%'")
    if users.present?
      users.each do |user|
        next if TrainerPlayer.where(user_id: user.id, trainer_user_id: current_user.id).blank?
        response[:error] = false
        response[:users].push(user.to_json(:include => [:user_information]))
        user_ids.push(user.id)
      end
    end

    uis = UserInformation.where("name like '%#{params[:search]}%'")
    uis = uis.where.not(user_id: user_ids) if user_ids.present?
    if uis.present?
      uis.each do |ui|
        user = User.find(ui.user_id)
        if user.present?
          next if TrainerPlayer.where(user_id: user.id, trainer_user_id: current_user.id).blank?
          response[:error] = false
          response[:users].push(user.to_json(:include => [:user_information]))
        end
      end
    end

    uis = UserInformation.where("sport like '%#{params[:search]}%'")
    uis = uis.where.not(user_id: user_ids) if user_ids.present?
    if uis.present?
      uis.each do |ui|
        user = User.find(ui.user_id)
        if user.present?
          next if TrainerPlayer.where(user_id: user.id, trainer_user_id: current_user.id).blank?
          response[:error] = false
          response[:users].push(user.to_json(:include => [:user_information]))
        end
      end
    end
    
    players = TrainerPlayer.where(trainer_user_id: current_user.id)
    response[:max] = players.length
    # ui = UserInformation.where("name like %#{params[:search]}%") if ui.blank?
    # if uis.present?
    #   uis.each do |ui|
    #     user = User.find(ui.user_id)
    #     if user.present?
    #       response[:error] = false
    #       response[:users].push(user)
    #     end
    #   end
    # end

    render json: response
  end

  def page_trainer_users
    page = params[:page].present? ? params[:page] : 1
    offset = 10 * (page.to_i - 1)
    players = TrainerPlayer.where(trainer_user_id: current_user.id).limit(10).offset(offset)
    array = []
    players.each do |player|
      user = User.find(player.user_id)
      array.push(user.to_json(:include => [:user_information])) if user.present?
    end
    render json: { :users =>  array, :max => TrainerPlayer.where(trainer_user_id: current_user.id).count }
  end
end
