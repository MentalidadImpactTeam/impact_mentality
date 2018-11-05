module ProfilesHelper
  def profile_stage_name(stage_id)
    Stage.find(stage_id).name
  end
end
