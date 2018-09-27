# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters
  layout "devise"
  
  # GET /resource/sign_up
  def new
    catalogos_registro
    @user_types = UserType.all.order(id: :asc)
    build_resource({})
    resource.build_user_information
    respond_with self.resource
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

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
    @heights = [['Estatura', 'vacio'],['-1.00m', '-1'],['1.00m', '1'],['1.10m', '1.1'],['1.20m', '1.2'],['1.30m', '1.3'],['1.40m', '1.4'],['1.50m', '1.5'],
    ['1.60m', '1.6'],['1.70m', '1.7'],['1.80m', '1.8'],['1.90m', '1.9'],['2.00m', '2'],['2.10m', '2.1'],['2.20m', '2.2'],['2.30m', '2.3'],['2.40m', '2.4'],['+2.40m', '+2.4']]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_information_attributes => [:user_type_id, :first_name, :last_name, :birth_date, :genre, :height, :weight, :sport, :position, :next_competition, :experience, :history_injuries, :pay_day, :pay_program, :goal_1, :goal_2]])
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
