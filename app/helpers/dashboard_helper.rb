module DashboardHelper
  def player_weeks(user)
    total_weeks = user.user_information.stage_count * 4
  end
end
