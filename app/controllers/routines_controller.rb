class RoutinesController < ApplicationController
    before_action :check_user_subscription

    def index
        @week_hash = [{ "day" => "LUNES", "description" => "", "active" => "" }, { "day" => "MARTES", "description" => "", "active" => "" }, { "day" => "MIERCOLES", "description" => "", "active" => "" }, 
                    { "day" => "JUEVES", "description" => "", "active" => "" }, { "day" => "VIERNES", "description" => "", "active" => "" }, { "day" => "SABADO", "description" => "", "active" => "" }]

        for date in Time.now.to_date.all_week do
            next if date.wday == 0
            @week_hash[date.wday - 1]["description"] = date_description(date)
        end

        today = Date.today
        # today = Date.parse("20181218")
        if today.wday != 0
            @week_hash[today.wday - 1]["active"] = 1 
        end
        @restday = today.wday == 0 ? true : false
        @mostrar_modal =  false
        @test = current_user.user_information.stage_week == 4 ? true : false
        if @restday
            routine_exist = 0
        else
            routine = UserRoutine.find_by(user_id: current_user.id, date: today)
            routine_exist = routine.present? ? RoutineExercise.where(user_routine_id: routine.id).count : 0
        end
        if routine_exist == 0 and !@restday
            @mostrar_modal = true
        elsif !@restday
            routine_exercises = RoutineExercise.where(user_routine_id: routine.id).order(group: :asc)
            @hash = { 1 => { "show" => 0, "exercises" => []}, 2 => { "show" => 0, "exercises" => []}, 3 => { "show" => 0, "exercises" => []}, 4 => { "show" => 0, "exercises" => []}, 5 => { "show" => 0, "exercises" => []} }
            routine_exercises.each do |routine_exercise|
                exercise = Exercise.find(routine_exercise.exercise_id)
                hash_exercise = { 
                    "name" => exercise.name,
                    "description" => exercise.description,
                    "category_id" => exercise.category_id,
                    "id" => routine_exercise.exercise_id, 
                    "routine_exercise_id" => routine_exercise.id,
                    "sets" => routine_exercise.set,
                    "reps" => routine_exercise.rep,
                    "done" => routine_exercise.done,
                    "test" => routine_exercise.test
                }
                @hash[routine_exercise.group]["exercises"].push(hash_exercise)
            end

            for i in 1..5
                group_count = RoutineExercise.where(user_routine_id: routine.id, group: i).count
                group_done = RoutineExercise.where(user_routine_id: routine.id, group: i, done: 1).count
                
                if group_count != group_done
                    @hash[i]["show"] = 1
                    break
                end
            end

            if @hash[5]["exercises"].length == 0
                groups_total = 4
                @hash.delete(5)
            else
                groups_total = 5
            end

            array_groups = []
            @hash.keys.each do |key|
                group_count = @hash[key]["exercises"].length
                done_count = 0
                @hash[key]["exercises"].each do |exercise|
                    if exercise["done"] == 1
                        done_count += 1
                    end
                end
                hash_group = { :count => group_count, :done => done_count }
                array_groups.push(hash_group)
            end

            @warm_width = 0
            @triserie_width = 0
            @finisher_width = 0
            @progress_name = ""
            @previous = ""
            @next = " SERIE #1 "
            @routine_finished = false
            array_groups.each_with_index do |group_counts, index|
                group = index + 1
                if group == 1
                    if group_counts[:count] == group_counts[:done]
                        @warm_width = 100
                    else
                        @warm_width = ((group_counts[:done].to_f / group_counts[:count].to_f) * 100).to_i
                    end
                    @progress_name = " WARM UP / PREHABS "
                    break if @hash[group]["show"] == 1
                elsif group == 2
                    if group_counts[:count] == group_counts[:done]
                        @triserie_width = groups_total == 4 ? 50 : 33
                    else
                        total_porcentage = groups_total == 4 ? 50 : 33
                        @triserie_width = ((group_counts[:done].to_f / group_counts[:count].to_f) * total_porcentage).to_i
                    end
                    @progress_name = " SERIE #1 "
                    @previous = " WARM UP / PREHABS "
                    @next = " SERIE #2 "
                    break if @hash[group]["show"] == 1
                elsif group == 3
                    @progress_name = " SERIE #2 "
                    @previous = " SERIE #1 "
                    @next = groups_total == 4 ? " FINISHERS " : " SERIE #3 "
                    break if @hash[group]["show"] == 1
                    if group_counts[:count] == group_counts[:done]
                        @triserie_width = groups_total == 4 ? 100 : 66
                    else
                        total_porcentage = groups_total == 4 ? 100 : 66
                        @triserie_width = ((group_counts[:done].to_f / group_counts[:count].to_f) * total_porcentage).to_i
                    end
                elsif group == 4
                    @progress_name = " SERIE #3 "
                    @previous = " SERIE #2 "
                    @next = " FINISHERS "         
                    if groups_total == 4
                        @progress_name = " FINISHERS "
                        @previous = " SERIE #2 "
                        @next = " DONE "
                        if group_counts[:count] == group_counts[:done]
                            @finisher_width = 100
                            @routine_finished = true
                            @progress_name = " DONE "
                            @previous = " FINISHERS"
                        else
                            @finisher_width = ((group_counts[:done].to_f / group_counts[:count].to_f) * 100).to_i
                        end
                        break if @hash[group]["show"] == 1    
                    else
                        if group_counts[:count] == group_counts[:done]
                            @triserie_width = 100
                        else
                            @triserie_width = ((group_counts[:done].to_f / group_counts[:count].to_f) * 100).to_i
                        end
                    end       
                elsif group == 5
                    @progress_name = " FINISHERS "
                    @previous = " SERIE #3 "
                    @next = " DONE "
                    if group_counts[:count] == group_counts[:done]
                        @finisher_width = 100
                        @routine_finished = true
                    else
                        @finisher_width = ((group_counts[:done].to_f / group_counts[:count].to_f) * 100).to_i
                    end
                end
            end
        end
    end

    def create
        user_routine = UserRoutine.where(user_id: current_user.id, date:  Date.today)
        if user_routine.blank?
            create_routine_complete()
            user_routine = UserRoutine.where(user_id: current_user.id, date: Date.today)
        end

        user_routine = user_routine.first

        current_user.user_information.stage_week = user_routine.stage_week if current_user.user_information.stage_week != user_routine.stage_week
        
        if current_user.user_information.stage_id != user_routine.stage_id
            current_user.user_information.stage_id = user_routine.stage_id 
            current_user.user_information.stage_process += 1
        end
        current_user.user_information.save

        # Si es sabado, hacer rutina de jueves
        weekday =  Time.now.to_date.wday == 6 ? 4 : Time.now.to_date.wday
        # weekday =  2
        if current_user.user_information.stage_week == 4
            # Si es la cuarta semana, es semana de pruebas, crear rutina de pruebas
            configuration =  TestConfiguration.where(day: weekday)
        else
            configuration =  StageConfiguration.where(stage_id: user_routine.stage_id, day: weekday)
        end
        
        configuration.each do |conf|
            routine_exercise = RoutineExercise.new
            routine_exercise.user_routine_id = user_routine.id
            routine_exercise.user_id = current_user.id
            routine_exercise.group = conf.group
            routine_exercise.done = 0
            exe_id = 0
            if conf.exercise_id.present?
                routine_exercise.exercise_id = conf.exercise_id
            else
                if conf.subcategory_id.present?
                    exercises = Exercise.where(subcategory_id: conf.subcategory_id).to_a
                elsif conf.category_id.present?
                    exercises = Exercise.where(category_id: conf.category_id).to_a
                end

                exercises = exercises.where(bar: 1) if conf.bar == 1
                exercises = exercises.where(liga: 1) if conf.liga == 1

                exercises = exercises.shuffle
                exercises.each do |exe_cat|
                    existe = RoutineExercise.find_by(user_routine_id: user_routine.id, exercise_id: exe_cat.id)
                    if existe.present?
                        next
                    else
                        routine_exercise.exercise_id = exe_cat.id
                        break
                    end
                end
            end
            if current_user.user_information.stage_week == 4
                if [1,2].include?(weekday) and routine_exercise.group != 1
                    routine_exercise.test = 1
                else
                    routine_exercise.test = 0
                end
                hash = test_configuration_sets_reps(params["values"], conf.category_id, weekday, current_user.user_information) 
            else
                routine_exercise.test = 0
                light_heavy_day = conf.heavy_day.nil? ? conf.light_day.nil? ? nil : "L"  : "H"
                hash = stage_configuration_sets_reps(params["values"], user_routine.stage_id, conf.category_id, routine_exercise.exercise_id, light_heavy_day, current_user.user_information.stage_week)
            end

            routine_exercise.set = hash[:sets] if hash[:sets].present?
            routine_exercise.rep = hash[:reps] if hash[:reps].present?
            routine_exercise.seconds_down = hash[:down] if hash[:down].present?
            routine_exercise.seconds_hold = hash[:hold] if hash[:hold].present?
            routine_exercise.seconds_uo = hash[:up] if hash[:up].present?
            routine_exercise.porcentage = hash[:porcentage] if hash[:porcentage].present?
            routine_exercise.yards = hash[:yards] if hash[:yards].present?
            routine_exercise.save
        end    
        render plain: "OK"
    end

    def create_routine_complete()
        first_day_routine = Date.today
        # 168 dias, 6 etapas de 4 semanas cada una
        last_day_routine = first_day_routine + 167
        
        week = 1
        stage = 1
        day = first_day_routine.wday == 0 ? 7 : first_day_routine.wday
        week = 0 if day == 7
        for date in first_day_routine..last_day_routine
            user_routine = UserRoutine.new
            user_routine.user_id = current_user.id
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

    def mark_exercise_done
        RoutineExercise.find(params[:id]).update(done: 1)
        today = Date.today
        routine = UserRoutine.find_by(user_id: current_user.id, date: today)
        count_routine_exercises = RoutineExercise.where(user_routine_id: routine.id).count
        count_routine_exercises_done = RoutineExercise.where(user_routine_id: routine.id, done: 1).count

        if count_routine_exercises == count_routine_exercises_done
            routine.done = 1
            routine.save
        end
        render plain: "OK"
    end

    def test_result
        test_result = TestResult.new
        test_result.user_id = current_user.id
        test_result.exercise_id = params["exercise_id"]
        test_result.routine_exercise_id = params["routine_exercise_id"]
        test_result.result = params["result"]
        test_result.stage_id = UserRoutine.where(user_id: current_user.id, date:  Date.today).first.stage_id
        test_result.save
        render plain: "OK"    
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

    def test_configuration_sets_reps(values, category, weekday, ui) 
        result = 0
        values.each {|a| result += a.to_i }
        result_quiz = result
        hash = { :sets => 0, :reps => 0 }

        if category == 1
            # FUNDAMENTALES
            hash[:sets] = 3 if result_quiz <= 15
            hash[:sets] = 2 if result_quiz <= 10

            hash[:reps] = 10 
        elsif category == 20 or weekday != 2 
            # AUXILIARES
            hash[:sets] = 2 

            hash[:reps] = 12
        end

        if weekday == 1
            if ui.sport == "Beisbol"
                hash[:yards] = 60
            else
                hash[:yards] = 40
            end
        end
        hash
    end

    private
    def check_user_subscription
        if current_user.user_conekta_subscription.present?
            if current_user.user_conekta_subscription.last.estatus == 0
                redirect_back(fallback_location: root_path)
            end
        end
    end
end
