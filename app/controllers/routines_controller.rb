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

        routine = UserRoutine.find_by(user_id: current_user.id, date: Time.now.to_date)
        if routine.present?
            exercises = RoutineExercise.where(user_routine_id: routine.id)
            @hash = { 1 => { "show" => 0, "exercises" => []}, 2 => { "show" => 0, "exercises" => []}, 3 => { "show" => 0, "exercises" => []}, 4 => { "show" => 0, "exercises" => []}, 5 => { "show" => 0, "exercises" => []} }
            exercises.each do |exercise|
                @hash[exercise.group]["exercises"].push({ "name" => Exercise.find(exercise.exercise_id).name, "id" => exercise.exercise_id, "routine_exercise_id" => exercise.id })
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
end
