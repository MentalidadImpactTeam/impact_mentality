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
    super
    user = User.find_by(email: params["user"]["email"])
    
    user.user_information.name = params['user']['user_information_attributes']['first_name'].squish.capitalize + " " + params['user']['user_information_attributes']['last_name'].squish.capitalize
    user.user_information.weight = user.user_information.weight.remove("kg").squish
    user.user_information.user_type_id = 3
    user.user_information.uid =  Random.rand(000000...999999).to_s.rjust(6, "0")

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

    customer = Conekta::Customer.create({
      :name => user.user_information.name,
      :email => user.email,
      :payment_sources => [{
        :type => 'card',
        :token_id => params["user"]["customer_token"]
      }]
    })
    payment_source   = customer.payment_sources.first

    user_conekta = UserConektaToken.new
    user_conekta.user_id = user.id
    user_conekta.token =  payment_source["id"]
    user_conekta.default = 1
    user_conekta.last_digits = payment_source["last4"]
    user_conekta.exp_month = payment_source["exp_month"]
    user_conekta.exp_year = payment_source["exp_year"]
    user_conekta.brand = payment_source["brand"].downcase
    user_conekta.save

    user.customer_token = customer.payment_sources.first.id
    user.active = 1
    user.save
    
    subscription = customer.create_subscription({
      :plan => "mensual"
    })

    user_subscription = UserConektaSubscription.new
    user_subscription.user_id = user.id 
    user_subscription.estatus = 1 
    user_subscription.start_date = Time.at(subscription.billing_cycle_start).to_date
    user_subscription.end_date = Time.at(subscription.billing_cycle_end).to_date
    user_subscription.conekta_subscription_token = subscription.id
    user_subscription.save
    
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
      user.user_information.first_name = params[:first_name]
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

  def catalogos_registro
    @heights = [['Estatura', 'vacio'],['-1.00m', '-1'],['1.00m', '1.00'],['1.10m', '1.10'],['1.20m', '1.20'],['1.30m', '1.30'],['1.40m', '1.40'],['1.50m', '1.50'],
    ['1.60m', '1.60'],['1.70m', '1.70'],['1.80m', '1.80'],['1.90m', '1.90'],['2.00m', '2.00'],['2.10m', '2.10'],['2.20m', '2.20'],['2.30m', '2.30'],['2.40m', '2.40'],['+2.40m', '+2.4']]
    @sports = [['Deporte', 'vacio'],['Multi-deporte', 'Multi'],['Futbol Americano', 'Futbol'],['Balocensto', 'Balocensto'],['Beisbol', 'Beisbol'],['Soccer', 'Soccer'],
    ['Hockey', 'Hockey'],['Hockey Sobre Pasto', 'Hockeycpasto'],['Atletismo', 'Atletismo'],['Golf', 'Golf'],['Tennis', 'Tennis'],['Tennis Country', 'TennisC'],
    ['Deporte de Combate', 'Combate'],['Rugby', 'Rugby'],['Lacrosse', 'Lacrosse'],['Natación', 'Natación'],['Voleibol', 'Voleibol'],['Lucha Olímpica', 'LuchaOli'],
    ['Porras y Baile', 'Porras'],['Ciclismo', 'Ciclismo'],['Maratón', 'Maratón'],['Correr', 'Correr'],['Handball', 'Handball'],['Triathlon', 'Triathlon'],['Carrera de Obstaculos', 'Carrera'],['Water Polo', 'Water']]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:customer_token, :user_information_attributes => [:user_type_id, :first_name, :last_name, :phone, :birth_date, :genre, :height, :weight, :sport, :position, :next_competition, :experience, :history_injuries, :pay_day, :pay_program, :goal_1, :goal_2]])
  end

  def user_params
    params.require(:user).permit(:email, :first_name)
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
    active_confirmation_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    active_confirmation_path
  end
end
