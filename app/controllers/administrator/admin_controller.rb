class Administrator::AdminController < ApplicationController
  before_action :check_if_admin
  layout "administrator"

  def list_users
    @user = User.joins(:user_information).where("user_type_id != 1")
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

  def list_exercises
    @categories = Category.all.order(id: :asc)
    @exercises = Exercise.where(category_id: 1).order(id: :asc)
  end

  def change_list_exercises
    render json: { :exercises => Exercise.where(category_id: params[:category_id]).order(id: :asc) }
  end

  def edit_exercise
    exercise = Exercise.find(params[:id])
    if exercise.present?
      exercise.category_id = params[:category_id]
      exercise.name = params[:name].squish
      exercise.description = params[:description]
      exercise.save
    end
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
