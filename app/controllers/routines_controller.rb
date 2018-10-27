class RoutinesController < ApplicationController

    def index
        @week_hash = [{ "day" => "LUNES", "description" => "", "active" => "" }, { "day" => "MARTES", "description" => "", "active" => "" }, { "day" => "MIERCOLES", "description" => "", "active" => "" }, 
                    { "day" => "JUEVES", "description" => "", "active" => "" }, { "day" => "VIERNES", "description" => "", "active" => "" }]

        for date in Time.now.to_date.all_week do
            next if [0,6].include?(date.wday)
            @week_hash[date.wday - 1]["description"] = date_description(date)
        end
        if ![0,6].include?(Time.now.wday)
            @week_hash[Time.now.wday - 1]["active"] = 1 
        else
            @week_hash[4]["active"] = 1 
        end

        @mostrar_modal = false
        routine = UserRoutine.find_by(user_id: current_user.id, date: Time.now.to_date)
        if routine.blank?
            @mostrar_modal = true
        else
            exercises = RoutineExercise.where(user_routine_id: routine.id)
            @hash = { 1 => { "show" => 0, "exercises" => []}, 2 => { "show" => 0, "exercises" => []}, 3 => { "show" => 0, "exercises" => []}, 4 => { "show" => 0, "exercises" => []}, 5 => { "show" => 0, "exercises" => []} }
            exercises.each do |exercise|
                hash_exercise = { 
                    "name" => Exercise.find(exercise.exercise_id).name,
                    "id" => exercise.exercise_id, 
                    "routine_exercise_id" => exercise.id,
                    "sets" => exercise.set,
                    "reps" => exercise.rep
                }
                @hash[exercise.group]["exercises"].push(hash_exercise)
            end
    
            for i in 1..5
                group_count = RoutineExercise.where(user_routine_id: routine.id, group: i).count
                group_done = RoutineExercise.where(user_routine_id: routine.id, group: i, done: 1).count
    
                @hash[i]["show"] = group_count == group_done ? 0 : 1
                break
            end
            puts @hash
        end
    end

    def date_description(date)
        description = date.day.to_s + " DE " + month_description(date.month) + " " + date.year.to_s 
    end

    def month_description(month)
        case month
        when 1
            return "ENERO"
        when 2
            return "FEBRERO"
        when 3
            return "MARZO"
        when 4
            return "ABRIL"
        when 5
            return "MAYO"
        when 6
            return "JUNIO"
        when 7
            return "JULIO"
        when 8
            return "AGOSTO"
        when 9
            return "SEPTIEMBRE"
        when 10
            return "OCTUBRE"
        when 11
            return "NOVIEMBRE"
        when 12
            return "DICIEMBRE"
        end
    end

    def create
        last_routine = UserRoutine.where(user_id: current_user.id).order(id: :desc)
        stage_week = ""
        if last_routine.present?
            last_routine = last_routine.first
            last_date = last_routine.date
            today = Time.now.to_date
            same_week = last_date.cweek == today.cweek
            if same_week
                stage_week = last_routine.stage_week
            else
                week_difference = TimeDifference.between(last_date, today).in_weeks
                stage_week = last_routine.stage_week + week_difference.to_i
            end
        else
            stage_week = 1
        end

        user_routine = UserRoutine.new
        user_routine.user_id = current_user.id
        user_routine.stage_id = current_user.user_information.stage_id
        user_routine.stage_week = stage_week
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
            routine_exercise.group = conf.group
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
            end
            light_heavy_day = conf.heavy_day.nil? ? conf.light_day.nil? ? nil : "L"  : "H"
            hash = stage_configuration_sets_reps(params["values"], user_routine.stage_id, conf.category_id, routine_exercise.exercise_id, light_heavy_day, stage_week)

            routine_exercise.set = hash[:sets]
            routine_exercise.rep = hash[:reps]
            routine_exercise.seconds_down = hash[:down] if hash[:down].present?
            routine_exercise.seconds_hold = hash[:hold] if hash[:hold].present?
            routine_exercise.seconds_uo = hash[:up] if hash[:up].present?
            routine_exercise.porcentage = hash[:porcentage] if hash[:porcentage].present?
            routine_exercise.save
            # hash['exe_id'] = exe_id
            # array.push(hash)
        end    
        render plain: "OK"
    end

    def list_exercises
        exercise = Exercise.find(params[:exercise_id])
        if exercise.present?
            all_category = Exercise.where(category_id: exercise.category_id).where.not(id: exercise.id)
            render json: all_category
        end
    end

    def change_exercise
        routine = RoutineExercise.find(params[:routine_id])
        if routine.present?
            routine.exercise_id = params[:exercise_id]
            routine.save

            render json: { "estatus" => "OK" }
        end
    end

    def stage_configuration_sets_reps(values, stage, category, exercise, light_heavy_day, week)
        result = 0
        values.each {|a| result += a.to_i }
        result_quiz = result
        hash = { :sets => 0, :reps => 0 }
        case stage
            when 1
                if category == 1
                    # FUNDAMENTALES
                    hash[:sets] = 5 if result_quiz <= 15
                    hash[:sets] = 4 if result_quiz <= 10
                    hash[:sets] = 3 if result_quiz <= 5

                    hash[:reps] = 12 if result_quiz <= 15
                    hash[:reps] = 10 if result_quiz <= 10
                    
                    # Aumentar 1 rep por semana
                    hash[:reps] = hash[:reps] + (week - 1)
                else
                    # AUXILIARES
                    hash[:sets] = 4 if result_quiz <= 15
                    hash[:sets] = 3 if result_quiz <= 5

                    hash[:reps] = 12 if result_quiz <= 15
                    hash[:reps] = 10 if result_quiz <= 10

                    # Aumentar 2 reps por semana
                    hash[:reps] = hash[:reps] + ((week - 1) * 2)
                end
            when 2
                if category == 1
                    # FUNDAMENTALES
                    hash[:sets] = 5 if result_quiz <= 15
                    hash[:sets] = 4 if result_quiz <= 10
                    hash[:sets] = 3 if result_quiz <= 5

                    hash[:reps] = 15 if result_quiz <= 15
                    hash[:reps] = 12 if result_quiz <= 10

                    # Aumentar 2 reps por semana
                    hash[:reps] = hash[:reps] + ((week - 1) * 2)
                else
                    # AUXILIARES
                    hash[:sets] = 4 if result_quiz <= 15
                    hash[:sets] = 3 if result_quiz <= 5

                    hash[:reps] = 15 if result_quiz <= 15
                    hash[:reps] = 12 if result_quiz <= 10

                    # Aumentar 2 reps por semana
                    hash[:reps] = hash[:reps] + ((week - 1) * 2)
                end
            when 3
                if !light_heavy_day.nil?
                    if light_heavy_day == "L"
                        # LIGHT DAY
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5

                        hash[:reps] = 6
                        hash[:down] = 3
                        hash[:hold] = 0
                        hash[:up] = 0
                        hash[:porcentage] = 60

                    else
                        # HEAVY DAY
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5

                        hash[:reps] = 3
                        hash[:down] = 3
                        hash[:hold] = 0
                        hash[:up] = 0
                        hash[:porcentage] = 75
                    end
                else
                    if category == 1
                        if [8,9].include?(exercise)
                            # CLEANS
                            hash[:sets] = 5 if result_quiz <= 15
                            hash[:sets] = 4 if result_quiz <= 10
                            hash[:sets] = 3 if result_quiz <= 5
    
                            hash[:reps] = 5
                            # Aumentar 1 rep por semana
                            hash[:reps] = hash[:reps] + (week - 1)  
                        elsif exercise == 6
                            # PUSH PRESS
                            hash[:sets] = 5 if result_quiz <= 15
                            hash[:sets] = 4 if result_quiz <= 10
                            hash[:sets] = 3 if result_quiz <= 5
    
                            hash[:reps] = 6
                            # Aumentar 1 rep por semana
                            hash[:reps] = hash[:reps] + (week - 1)  
                        end
                    elsif category == 4
                        # PECHO FUERZA
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 8
                        # Aumentar 1 rep por semana
                        hash[:reps] = hash[:reps] + (week - 1) 
                    else
                        # AUXILIARES
                        hash[:sets] = 4 if result_quiz <= 15
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 10 if result_quiz <= 15
                        hash[:reps] = 8 if result_quiz <= 10
    
                        # Aumentar 1 rep por semana
                        hash[:reps] = hash[:reps] + (week - 1)
                    end
                end
            when 4
                if !light_heavy_day.nil?
                    if light_heavy_day == "L"
                        # LIGHT DAY
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5

                        hash[:reps] = 6
                        hash[:down] = 0
                        hash[:hold] = 3
                        hash[:up] = 0
                        hash[:porcentage] = 60

                    else
                        # HEAVY DAY
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5

                        hash[:reps] = 3
                        hash[:down] = 0
                        hash[:hold] = 3
                        hash[:up] = 0
                        hash[:porcentage] = 75
                    end
                else
                    if category == 1
                        if [8,9].include?(exercise)
                            # CLEANS
                            hash[:sets] = 5 if result_quiz <= 15
                            hash[:sets] = 4 if result_quiz <= 10
                            hash[:sets] = 3 if result_quiz <= 5
    
                            hash[:reps] = 5
                            # Aumentar 1 rep por semana
                            hash[:reps] = hash[:reps] + (week - 1)  
                        elsif exercise == 6
                            # PUSH PRESS
                            hash[:sets] = 5 if result_quiz <= 15
                            hash[:sets] = 4 if result_quiz <= 10
                            hash[:sets] = 3 if result_quiz <= 5
    
                            hash[:reps] = 6
                            # Aumentar 1 rep por semana
                            hash[:reps] = hash[:reps] + (week - 1)  
                        end
                    elsif category == 4
                        # PECHO FUERZA
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 8
                        # Aumentar 1 rep por semana
                        hash[:reps] = hash[:reps] + (week - 1) 
                    else
                        # AUXILIARES
                        hash[:sets] = 4 if result_quiz <= 15
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 12 if result_quiz <= 15
                        hash[:reps] = 10 if result_quiz <= 10
                        hash[:reps] = 8 if result_quiz <= 5
    
                        # Aumentar 1 rep por semana
                        hash[:reps] = hash[:reps] + (week - 1)
                    end
                end
            when 5
                if !light_heavy_day.nil?
                    if light_heavy_day == "L"
                        # LIGHT DAY
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5

                        hash[:reps] = 6
                        hash[:down] = 0
                        hash[:hold] = 0
                        hash[:up] = 0
                        hash[:porcentage] = 60

                    else
                        # HEAVY DAY
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5

                        hash[:reps] = 3
                        hash[:down] = 0
                        hash[:hold] = 0
                        hash[:up] = 0
                        hash[:porcentage] = 75
                    end
                else
                    if category == 1
                        if [8,9].include?(exercise)
                            # CLEANS
                            hash[:sets] = 5 if result_quiz <= 15
                            hash[:sets] = 4 if result_quiz <= 10
                            hash[:sets] = 3 if result_quiz <= 5
    
                            hash[:reps] = 4
                            # Aumentar 1 rep por semana
                            hash[:reps] = hash[:reps] + (week - 1)  
                        elsif exercise == 6
                            # PUSH PRESS
                            hash[:sets] = 5 if result_quiz <= 15
                            hash[:sets] = 4 if result_quiz <= 10
                            hash[:sets] = 3 if result_quiz <= 5
    
                            hash[:reps] = 6
                            # Aumentar 1 rep por semana
                            hash[:reps] = hash[:reps] + (week - 1)  
                        end
                    elsif category == 4
                        # PECHO FUERZA
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 8
                        # Aumentar 1 rep por semana
                        hash[:reps] = hash[:reps] + (week - 1) 
                    else
                        # AUXILIARES
                        hash[:sets] = 4 if result_quiz <= 15
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 12 if result_quiz <= 15
                        hash[:reps] = 10 if result_quiz <= 10
                        hash[:reps] = 8 if result_quiz <= 5
    
                        # Aumentar 1 rep por semana
                        hash[:reps] = hash[:reps] + (week - 1)
                    end
                end
            when 6
                if !light_heavy_day.nil?
                    if light_heavy_day == "L"
                        # LIGHT DAY
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5

                        hash[:reps] = 6
                        hash[:down] = 0
                        hash[:hold] = 0
                        hash[:up] = 0
                        hash[:porcentage] = 50

                    else
                        # HEAVY DAY
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5

                        hash[:reps] = 4
                        hash[:down] = 0
                        hash[:hold] = 0
                        hash[:up] = 0
                        hash[:porcentage] = 65
                    end
                else
                    if category == 1
                        if [8,9].include?(exercise)
                            # CLEANS
                            hash[:sets] = 5 if result_quiz <= 15
                            hash[:sets] = 4 if result_quiz <= 10
                            hash[:sets] = 3 if result_quiz <= 5
    
                            hash[:reps] = 4
                            # Aumentar 1 rep por semana
                            hash[:reps] = hash[:reps] + (week - 1)  
                        elsif exercise == 6
                            # PUSH PRESS
                            hash[:sets] = 5 if result_quiz <= 15
                            hash[:sets] = 4 if result_quiz <= 10
                            hash[:sets] = 3 if result_quiz <= 5
    
                            hash[:reps] = 6
                            # Aumentar 1 rep por semana
                            hash[:reps] = hash[:reps] + (week - 1) 
                        elsif exercise == 11
                            # push press 1 mano c/desplante
                            hash[:sets] = 5 if result_quiz <= 15
                            hash[:sets] = 4 if result_quiz <= 10
                            hash[:sets] = 3 if result_quiz <= 5
    
                            hash[:reps] = 5     
                            # Aumentar 1 rep por semana
                            hash[:reps] = hash[:reps] + (week - 1)  
                        end
                    elsif category == 4
                        # PECHO FUERZA
                        hash[:sets] = 5 if result_quiz <= 15
                        hash[:sets] = 4 if result_quiz <= 10
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 8
                        # Aumentar 1 rep por semana
                        hash[:reps] = hash[:reps] + (week - 1) 
                    elsif category == 16
                        # PIERNA SALTOS
                        hash[:sets] = 4 if result_quiz <= 15
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 6
                        # Aumentar 1 rep por semana
                        hash[:reps] = hash[:reps] + (week - 1)
                    elsif category == 18
                        # PIERNA SALTOS
                        hash[:sets] = 4 if result_quiz <= 15
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 8
                        # Aumentar 2 reps por semana
                        hash[:reps] = hash[:reps] + ((week - 1) * 2)
                    else
                        # AUXILIARES
                        hash[:sets] = 4 if result_quiz <= 15
                        hash[:sets] = 3 if result_quiz <= 5
    
                        hash[:reps] = 12 if result_quiz <= 15
                        hash[:reps] = 10 if result_quiz <= 10
                        hash[:reps] = 8 if result_quiz <= 5
    
                        # Aumentar 1 rep por semana
                        hash[:reps] = hash[:reps] + (week - 1)
                    end
                end
        end
        hash
    end
end
