# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters
  before_action :catalogos_registro, only: [ :create, :new ]
  layout "devise"
  
  # GET /resource/sign_up
  def new
    @user_types = UserType.all.order(id: :asc)
    build_resource({})
    resource.build_user_information
    respond_with self.resource
  end

  # POST /resource
  def create
    trainer_code =  params['user']['trainer_code']
    build_resource(sign_up_params)
    resource.skip_confirmation! if params['user']['user_information_attributes']['user_type_id'].to_i == 2
    resource.trainer_code = nil
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
    user = User.find_by(email: params["user"]["email"])
    
    if params['user']['user_information_attributes']['user_type_id'].to_i == 3
      # Si es usuario
      user.user_information.name = params['user']['user_information_attributes']['first_name'].squish.capitalize + " " + params['user']['user_information_attributes']['last_name'].squish.capitalize
      user.user_information.name = user.user_information.name.split.map(&:capitalize).join(' ')
      user.user_information.weight = user.user_information.weight.remove("kg").squish

      if trainer_code.present?
        user_information = UserInformation.find_by(uid: trainer_code)

        tp = TrainerPlayer.new
        tp.trainer_user_id = user_information.user_id
        tp.user_id = user.id
        tp.save

        user.active = 2
      end

      if params["user"]["customer_token"].present? and trainer_code.blank?
        customer = Conekta::Customer.find(params["user"]["customer_token"])
        payment_source = customer.payment_sources.last
    
        user_conekta = UserConektaToken.new
        user_conekta.user_id = user.id
        user_conekta.token =  payment_source["id"]
        user_conekta.default = 1
        user_conekta.last_digits = payment_source["last4"]
        user_conekta.exp_month = payment_source["exp_month"]
        user_conekta.exp_year = payment_source["exp_year"]
        user_conekta.brand = payment_source["brand"].downcase
        user_conekta.save
    
        user.customer_token = params["user"]["customer_token"]
        user.active = 1
        
        subscription = customer.subscription
        
        user.user_information.plan = subscription.plan_id
    
        user_subscription = UserConektaSubscription.new
        user_subscription.user_id = user.id 
        user_subscription.estatus = 1 
        user_subscription.start_date = Time.at(subscription.billing_cycle_start).to_date
        user_subscription.end_date = Time.at(subscription.billing_cycle_end).to_date
        user_subscription.conekta_subscription_token = subscription.id
        user_subscription.save
      end
    elsif params['user']['user_information_attributes']['user_type_id'].to_i == 2
      # Si es entrenador
      user.active = 0
    end
    user.save

    user.user_information.uid = get_random_uid()

    if params['user']['user_information_attributes']['next_competition'].present?
      difference = TimeDifference.between(Time.now.to_date, params['user']['user_information_attributes']['next_competition'].to_date).in_general
      if difference[:months] >= 6
        # Si los meses hasta la prox competencia son mayores a 6, creamos la rutina completa, y luego creamos lo que falta de la rutina
        # dependiendo del ultimo dia creado hacia la fecha de prox competencia
        create_routine_complete(user)

        first_day_routine = Date.today
        # 168 dias, 6 etapas de 4 semanas cada una
        last_day_routine = first_day_routine + 167

        stage, week, count = create_routine_from_next_competition(last_day_routine, params['user']['user_information_attributes']['next_competition'].to_date)

        user.user_information.stage_id = 1
        user.user_information.stage_week = 1
        user.user_information.stage_count = count
        user.user_information.stage_process = 1
        user.user_information.save
      else
        stage, week, count = create_routine_from_next_competition(Date.today, params['user']['user_information_attributes']['next_competition'].to_date)
          
        user.user_information.stage_id = stage
        user.user_information.stage_week = week
        user.user_information.stage_count = 6
        user.user_information.stage_process = 1 
        user.user_information.save
      end
    else
      # Si no ingresa fecha prox competencia, crear rutina completa
      create_routine_complete(user)

      user.user_information.stage_count = 6
      user.user_information.stage_process = 1 
      user.user_information.stage_id = 1
      user.user_information.stage_week = 1
      user.user_information.save
    end
    
  end

  def create_conekta_subscription
    customer = Conekta::Customer.create({
      :name => params["name"],
      :email => params["email"],
      :payment_sources => [{
        :type => 'card',
        :token_id => params["token"]
      }]
    })
    customer.payment_sources.first
    subscription = customer.create_subscription({
      :plan => params["plan"]
    })

    if subscription['status'] == "active"
      json = { :response => subscription } 
    else
      customer.delete
      json = { :error => true } 
    end

    render json: json
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

  def create_routine_from_next_competition(start_date, end_date)
    week = 4
    stage = 6
    count = 1
    day = end_date.wday == 0 ? 7 : end_date.wday
    next_competition_date = end_date
    array = []
    while next_competition_date >= start_date
      hash = { :date => next_competition_date, :day => day, :week => week, :stage => stage }
      array.push(hash)
      next_competition_date = next_competition_date - 1.day

      day -= 1
      if day == 0
        day = 7
        week -= 1
        if week == 0
          stage -= 1
          count += 1
          week = 4
        end
      end
    end

    array.reverse.each do |routine_date|
      user_routine = UserRoutine.new
      user_routine.user_id = user.id
      user_routine.stage_id = routine_date[:stage]
      user_routine.stage_week = routine_date[:week]
      user_routine.date = routine_date[:date]
      user_routine.day = routine_date[:day]
      user_routine.done = routine_date[:day] == 7 ? 1 : 0 # Guardar los domingos como rutinas acabadas
      user_routine.save
    end

    return stage, week, count
  end

  # GET /resource/edit
  def edit
    user = User.find(params[:id])
    user.skip_reconfirmation! 
    if user.update(user_params)
      user.user_information.name = params[:name].split.map(&:capitalize).join(' ')
      user.user_information.save
      render plain: "OK"
    else
      render plain: "NO"
    end
  end

  # PUT /resource
  def update
    if current_user.update(user_params)
      render plain: "OK"
    else
      render plain: "NO"
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def checkuser
    render :json => { 'existe' => User.find_by(email: params[:username]).present? }
  end

  def check_trainer_code
    user_information = UserInformation.find_by(uid: params["trainer"])

    if user_information.blank?
      response =  { :error => true, :mensaje => 'No se encontro el entrenador ingresado.' }
    elsif user_information.user_type_id != 2
      response =  { :error => true, :mensaje => 'El codigo ingresado no es de un entrenador.' }
    elsif user_information.user.active == 0
      response =  { :error => true, :mensaje => 'La cuenta del entrenador no esta activa.' }
    else
      player_count = TrainerPlayer.where(trainer_user_id: user_information.user_id).count
      if (player_count + 1) > user_information.player_plan
        response =  { :error => true, :mensaje => "Ya estan ingresados el numero maximo de jugadores para el entrenador seleccionado." }
      else
        response =  { :error => false }
      end
    end
    render json: response
  end

  def catalogos_registro
    @heights = [['Estatura', ''],['-1.00m', '-1'],['1.00m', '1.00'],['1.10m', '1.10'],['1.20m', '1.20'],['1.30m', '1.30'],['1.40m', '1.40'],['1.50m', '1.50'],
    ['1.60m', '1.60'],['1.70m', '1.70'],['1.80m', '1.80'],['1.90m', '1.90'],['2.00m', '2.00'],['2.10m', '2.10'],['2.20m', '2.20'],['2.30m', '2.30'],['2.40m', '2.40'],['+2.40m', '+2.4']]
    @sports = [['Deporte', ''],['Multi-deporte', 'Multi'],['Futbol Americano', 'Futbol'],['Balocensto', 'Balocensto'],['Beisbol', 'Beisbol'],['Soccer', 'Soccer'],
    ['Hockey', 'Hockey'],['Hockey Sobre Pasto', 'Hockeycpasto'],['Atletismo', 'Atletismo'],['Golf', 'Golf'],['Tennis', 'Tennis'],['Tennis Country', 'TennisC'],
    ['Deporte de Combate', 'Combate'],['Rugby', 'Rugby'],['Lacrosse', 'Lacrosse'],['Natación', 'Natación'],['Voleibol', 'Voleibol'],['Lucha Olímpica', 'LuchaOli'],
    ['Porras y Baile', 'Porras'],['Ciclismo', 'Ciclismo'],['Maratón', 'Maratón'],['Correr', 'Correr'],['Handball', 'Handball'],['Triathlon', 'Triathlon'],['Carrera de Obstaculos', 'Carrera'],['Water Polo', 'Water']]
  end

  def get_random_uid
    uid = ""
    while true
      uid = Random.rand(000000...999999).to_s.rjust(6, "0")
      break if UserInformation.find_by(uid: uid).blank?
    end
    return uid
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:customer_token, :trainer_code, :user_information_attributes => [:user_type_id, :name, :first_name, :last_name, :phone, :birth_date, :school, :genre, :height, :weight, :sport, :position, :next_competition, :experience, :history_injuries, :pay_day, :pay_program, :goal_1, :goal_2]])
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if resource.user_information.user_type_id == 2
      active_trainer_confirmation_path
    else
      active_confirmation_path
    end
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    if resource.user_information.user_type_id == 2
      active_trainer_confirmation_path
    else
      active_confirmation_path
    end
  end
end
