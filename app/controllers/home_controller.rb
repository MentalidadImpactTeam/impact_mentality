class HomeController < ApplicationController

  def index
    @stages = Stage.all.order(id: :asc)
    @days = [['Seleccionar', 0],['Lunes', 1],['Martes', 2],['Miercoles', 3],['Jueves', 4],['Viernes', 5]]
    # @configuration = StageConfiguration.where(stage_id: 1, day: 1)
  end

  def rutinas
    configuration =  StageConfiguration.where(stage_id: params[:stage_id], day: params[:day])
    array = []
    configuration.each do |conf|
      hash = {}
      hash['category'] = Category.find(conf.category_id).name
      hash['subcategory'] = conf.subcategory_id.present? ? Subcategory.find(conf.subcategory_id).name : ""
      hash['exercise_cat'] = conf.exercise_id.present? ? Exercise.find(conf.exercise_id).name : ""
      exe_id = 0
      if conf.exercise_id.present?
        hash['exercise'] = Exercise.find(conf.exercise_id).name
        exe_id = conf.id
      else
        if conf.subcategory_id.present?
          exercises = Exercise.where(subcategory_id: conf.subcategory_id).to_a
        elsif conf.category_id.present?
          exercises = Exercise.where(category_id: conf.category_id).to_a
        end
        exercises = exercises.shuffle
        exercises.each do |exe_cat|
          if array.length == 0
            hash['exercise'] = exe_cat.name
            exe_id = exe_cat.id
            break
          else
            existe = array.select { |ha| ha['exe_id'] == exe_cat.id }
            if existe.length > 0
              next
            else
              hash['exercise'] = exe_cat.name
              exe_id = exe_cat.id
              break
            end
          end
        end
      end
      hash['exe_id'] = exe_id
      array.push(hash)
    end
    # byebug
    render :json => array
  end
end
