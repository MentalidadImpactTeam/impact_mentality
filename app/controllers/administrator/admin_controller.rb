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

  def show_user
    @user = User.find(params[:id])
    @subscription = UserConektaSubscription.where(user_id: params[:id]).order(id: :desc).limit(1).first
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
end
