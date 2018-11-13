module Administrator::AdminHelper
  def lista_estatus(estatus)
    if estatus == 1
      "ACTIVO"
    else
      "INACTIVO"
    end
  end
end
