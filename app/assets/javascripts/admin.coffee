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
  $('.row_hover').on 'click', ->
    window.location.href = "/administrator/" + $(this).find(".id_usuario").text()
    return

AdministratorController::show = ->
  $(".admin_regresar").click ->
    window.location.href = "/administrator/"
    return
  $('.sistema_d_editar').click (event) ->
    nom = $('#admin_infoentrenador_nombre').text()
    email = $('#admin_correo').text()
    event.preventDefault();
    swal(
      html: '<div> Escribe el nuevo nombre de usuario </div>' + '<input type="text" id="nombre" class="swal2-input" value="' + nom + '">' + '<div> Escribe el nuevo correo electrónico </div>' + '<input type="text" id="correo" class="swal2-input" value="' + email + '">'
      title: 'Modifica la información del usuario'
      inputAttributes: autocapitalize: 'off'
      showCancelButton: true
      confirmButtonText: 'Guardar'
      showCloseButton: true).then (result) ->
        nuevonom = $('#nombre').val()
        nuevomail = $('#correo').val()
        $.ajax
          type: "GET"
          url: "/users/edit/"
          data: id: $("#admin_id").text(), user: { email: nuevomail }, first_name: nuevonom 
          dataType: "text",
          success: (data) ->
            return
        $('#admin_infoentrenador_nombre').text nuevonom
        $('#admin_correo').text nuevomail
        return
    return
  return