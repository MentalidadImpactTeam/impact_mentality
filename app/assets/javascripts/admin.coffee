AdministratorController = Paloma.controller('Administrator')
AdministratorController::index = ->
  $('.back_arrow_jugadores').on 'click', ->
    alert 'flecha para atras'
    return
  $('.foward_arrow_jugadores').on 'click', ->
    alert 'flecha para enfrente'
    return
  $('.add_jugadores').on 'click', ->
    swal
      title: '<strong>Agrega Jugador</strong>'
      type: 'info'
      html: '<input id="agregar_jugador" placeholder="  ID, Nombre, Correo Electrónico">'
      showCloseButton: true
      showCancelButton: true
      focusConfirm: true
      confirmButtonText: 'Agregar'
      confirmButtonAriaLabel: 'Thumbs up, great!'
      cancelButtonText: 'Cancelar'
    return
  $('.dashboard_jugador').on 'click', ->
    alert 'Entra a dashboard de jugador'
    return

