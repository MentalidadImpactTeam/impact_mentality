PlanesController = Paloma.controller('Planes')
PlanesController::index = ->
    metodos_menu("PLANES")
    $('#plan_mensual').on 'click', ->
        alert ''
    return