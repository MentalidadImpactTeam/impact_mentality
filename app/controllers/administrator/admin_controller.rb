class Administrator::AdminController < ApplicationController
  before_action :check_if_admin
  layout "administrator"

  def list_users
    @user = User.joins(:user_information).where("user_type_id != 1 and active = 1").limit(15).offset(0)
  end

  def page_users
    page = params[:page].present? ? params[:page] : 1
    offset = 15 * (page.to_i - 1)
    users = User.select("users.id, user_informations.uid, user_informations.name, user_informations.user_type_id ").joins(:user_information).where("user_type_id != 1 and active = 1").limit(15).offset(offset)
    array = []
    users.each do |user|
      subscription = user.user_conekta_subscription
      hash = { :id => user.id, :uid => user.uid, :name => user.name, :user_type_id => user.user_type_id }
      if subscription.present?
        subscription = subscription.last
        hash[:start_date] = subscription.start_date.strftime("%d/%m/%Y")
        hash[:end_date] = subscription.end_date.strftime("%d/%m/%Y")
        hash[:estatus] = subscription.estatus
      end
      array.push(hash)
    end
    render json: { :users =>  array }
  end

  def new_user
  end

  def create_user
    user = User.new
    user.email = params[:user][:email]
    user.password = params[:user][:password]
    user.active = 1
    user.skip_confirmation!
    user.save

    ui = UserInformation.new
    ui.user_id = user.id
    ui.user_type_id = 3
    ui.stage_id = 1
    ui.stage_week = 1
    ui.stage_count = 6
    ui.stage_process = 1
    ui.first_name = params[:user][:user_information][:first_name]
    ui.last_name = params[:user][:user_information][:last_name]
    ui.name = ui.first_name + " " + ui.last_name
    ui.next_competition = params[:user][:user_information][:next_competition]
    ui.sport = params[:user][:user_information][:sport]
    ui.position = params[:user][:user_information][:position]

    uid = ""
    while true
      uid = Random.rand(000000...999999).to_s.rjust(6, "0")
      break if UserInformation.find_by(uid: uid).blank?
    end

    ui.uid =  uid
    ui.save

    create_routine_complete(user)

    redirect_to administrator_users_url
  end

  def show_user
    @user = User.find(params[:id])
    @subscription = UserConektaSubscription.where(user_id: params[:id]).order(id: :desc).limit(1).first
  end

  def change_user_plan
    user = User.find(params[:id])
    customer = Conekta::Customer.find(user.customer_token)
    plan = user.user_information.user_type_id == 2 ? "entrenador_" + params[:plan] : params[:plan]
    subscription = customer.subscription.update({
      :plan => plan
    })

    if subscription['status'] == "active"
      if user.user_information.user_type_id == 2 
        user.active = 1
        user.save
        
        user.user_information.player_plan = params[:plan]
        user.user_information.save
      end

      if user.active == 0
        user.active = 1
        user.save
      end
    end
    # user.user_information.plan = params[:plan]
    # user.user_information.save
    render plain: "OK"
  end

  def search_users
    uis = UserInformation.where("name like '%" + params[:search] + "%'")
    users = []
    if uis.present?
      uis.each do |ui|
        suscription = UserConektaSubscription.find_by(user_id: ui.user.id, estatus: 1)
        information = UserInformation.select(:uid, :name).find_by(user_id: ui.user.id)
        user = eval(ui.user.to_json)
        user["suscription"] = suscription
        user["information"] = information
        users.push(user)
      end
    end
    render json: { :users => users }
  end

  def delete_user
    user = User.find(params[:id])
    user.update(active: 0)

    ui = user.user_conekta_subscription.last
    ui.estatus = 0
    ui.save

    customer = Conekta::Customer.find(user.customer_token)
    subscription = customer.subscription.pause

    render plain: "OK"
  end

  def change_user_type
    user = User.find(params[:user_id])
    user.user_information.user_type_id = eval(params[:type]) ? 2 : 3
    user.user_information.save

    render plain: "OK"
  end

  def list_exercises
    @categories = Category.all.order(id: :asc)
    @exercises = Exercise.where(category_id: 1).order(id: :asc)
  end

  def change_list_exercises
    render json: { :exercises => Exercise.where(category_id: params[:category_id]).order(id: :asc) }
  end

  def add_edit_exercise
    exercise = params[:id].present? ? Exercise.find(params[:id]) : Exercise.new
    exercise.category_id = params[:category_id]
    exercise.name = params[:name].squish
    exercise.description = params[:description]
    exercise.url = params[:link]
    exercise.save

    render plain: "OK"
  end

  def delete_exercise
    Exercise.delete(params[:id])
    render plain: "OK"
  end

  def search_exercises
    render json: { :exercises => Exercise.where("name like '%" + params[:search] + "%' and category_id = #{params[:category_id]}") }
  end

  private
  def check_if_admin
    redirect_back(fallback_location: root_path) if current_user.user_information.user_type_id != 1
  end

  def create_routine_complete(user)
    first_day_routine = Date.today
    # 168 dias, 6 etapas de 4 semanas cada una
    last_day_routine = first_day_routine + 167
    
    week = 1
    stage = 1
    day = first_day_routine.wday == 0 ? 7 : first_day_routine.wday
    week = 0 if day == 7
    for date in first_day_routine..last_day_routine
      user_routine = UserRoutine.new
      user_routine.user_id = user.id
      user_routine.stage_id = stage
      user_routine.stage_week = week
      user_routine.date = date
      user_routine.day = day
      user_routine.done = day == 7 ? 1 : 0
      user_routine.save

      break if stage == 6 and week == 4 and day == 7

      day += 1
      
      if day == 8
        day = 1
        week += 1
        if week == 5
          week = 1
          stage += 1
        end
      end
    end
  end
end
