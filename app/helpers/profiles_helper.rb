module ProfilesHelper
  def profile_stage_name(stage_id)
    Stage.find(stage_id).name
  end

  def profile_trainer_name(trainer)
    if trainer.present?
      user = UserInformation.find_by(user_id: trainer.trainer_user_id)
      user.name
    else
      "No cuenta con entrenador"
    end
  end
end
