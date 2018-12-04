module Administrator::AdminHelper
  def lista_estatus(subscription)
    if subscription.present?
      if subscription.last.estatus == 1
        "ACTIVO"
      else
        "INACTIVO"
      end
    else
      "ACTIVO"
    end
  end
end
