class DashboardController < ApplicationController
  before_action :login_required

  def index
    routine = UserRoutine.find_by(user_id: current_user.id, date: Time.now.to_date)
    if routine.blank?
      user_routine = UserRoutine.new
      user_routine.user_id = current_user.id
      user_routine.stage_id = 1
      user_routine.date = Time.now.to_date
      user_routine.done = 0
      user_routine.save

      weekday =  [0,6].include?(Time.now.to_date.wday) ? 5 : Time.now.to_date.wday
      configuration =  StageConfiguration.where(stage_id: user_routine.stage_id, day: weekday)
      # array = []
      configuration.each do |conf|
        routine_exercise = RoutineExercise.new
        routine_exercise.user_routine_id = user_routine.id
        routine_exercise.user_id = current_user.id
        routine_exercise.done = 0
        # hash = {}
        # hash['category'] = Category.find(conf.category_id).name
        # hash['subcategory'] = conf.subcategory_id.present? ? Subcategory.find(conf.subcategory_id).name : ""
        # hash['exercise_cat'] = conf.exercise_id.present? ? Exercise.find(conf.exercise_id).name : ""
        exe_id = 0
        if conf.exercise_id.present?
          # hash['exercise'] = Exercise.find(conf.exercise_id).name
          # exe_id = conf.id
          routine_exercise.exercise_id = conf.exercise_id
        else
          if conf.subcategory_id.present?
            exercises = Exercise.where(subcategory_id: conf.subcategory_id).to_a
          elsif conf.category_id.present?
            exercises = Exercise.where(category_id: conf.category_id).to_a
          end
          exercises = exercises.shuffle
          exercises.each do |exe_cat|
            existe = RoutineExercise.find_by(user_routine_id: user_routine.id, exercise_id: exe_cat.id)
            if existe.present?
              next
            else
              # hash['exercise'] = exe_cat.name
              # exe_id = exe_cat.id
              routine_exercise.exercise_id = exe_cat.id
              break
            end
            # if array.length == 0
            #   # hash['exercise'] = exe_cat.name
            #   # exe_id = exe_cat.id
            #   routine_exercise.exercise_id = exe_cat.id
            #   break
            # else
            #   # existe = array.select { |ha| ha['exe_id'] == exe_cat.id }
            #   existe = RoutineExercise.find_by(user_routine_id: user_routine.id, exercise_id: exe_cat.id)
            #   if existe.present?
            #     next
            #   else
            #     # hash['exercise'] = exe_cat.name
            #     # exe_id = exe_cat.id
            #     routine_exercise.exercise_id = exe_cat.id
            #     break
            #   end
            # end
          end
          routine_exercise.save
        end
        # hash['exe_id'] = exe_id
        # array.push(hash)
      end
    end
  end
end
