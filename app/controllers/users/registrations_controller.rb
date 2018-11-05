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

    user_conekta = UserConektaToken.new
    user_conekta.user_id = user.id
    user_conekta.token = params["user"]["customer_token"]
    user_conekta.save

    user.user_information.weight = user.user_information.weight.remove("kg").squish

    if params['user']['user_information_attributes']['next_competition'].present?
      difference = TimeDifference.between(Time.now.to_date, params['user']['user_information_attributes']['next_competition'].to_date).in_general
      if difference[:months] >= 6
        user.user_information.stage_id = 1
        user.user_information.stage_week = 1
        user.user_information.save
      else
        stage = 7
        week = 1
        if difference[:weeks] == 0
          stage -= (difference[:months])
        else
          stage -= (difference[:months])
          week = 5 - difference[:weeks]
          week = 1 if week == 0
        end

        user.user_information.stage_id = stage
        user.user_information.stage_week = week
        user.user_information.save
      end
    else
      user.user_information.stage_id = 1
      user.user_information.stage_week = 1
      user.user_information.save
    end

    name = user.user_information.first_name.squish + " " + user.user_information.last_name.squish
    customer = Conekta::Customer.create({
      :name => name,
      :email => user.email,
      :payment_sources => [{
        :type => 'card',
        :token_id => params["user"]["customer_token"]
      }]
    })

    user.customer_token = customer.id
    user.active = 1
    user.save
    
    subscription = customer.create_subscription({
      :plan => "mensual"
    })

    redirect_to active_confirmation_path
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:customer_token, :user_information_attributes => [:user_type_id, :first_name, :last_name, :birth_date, :genre, :height, :weight, :sport, :position, :next_competition, :experience, :history_injuries, :pay_day, :pay_program, :goal_1, :goal_2]])
  end

  def user_params
    params.require(:user).permit(:email)
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
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
