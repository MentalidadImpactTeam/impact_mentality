module DashboardHelper
  def player_weeks(user)
    total_weeks = user.user_information.stage_count * 4
  end

  def dashboard_exercise_name(exercise_id)
    exercise = Exercise.find(exercise_id)
    if exercise.present?
      exercise.name
    else
      ""
    end
  end
end
