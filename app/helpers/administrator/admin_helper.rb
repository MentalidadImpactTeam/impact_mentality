module Administrator::AdminHelper
  def lista_estatus(user)
    if user.active != 0
      "ACTIVO"
    else
      "INACTIVO"
    end
  end
end
