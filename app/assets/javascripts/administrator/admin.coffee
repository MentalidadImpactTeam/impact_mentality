AdministratorController = Paloma.controller('Administrator/Admin')
AdministratorController::list_users = ->
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
    window.location.href = "/administrator/users/" + $(this).find(".hidden_id").val()
    return

AdministratorController::show_user = ->
  $(".admin_regresar").click ->
    window.location.href = "/administrator/users"
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

AdministratorController::list_exercises = ->
  $('.administrador_tacha').click ->
    swal(
      title: '¿Estás seguro que deseas borrar?'
      text: 'No podras recuperar esta rutina'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#ff1d25'
      cancelButtonColor: '#333333'
      confirmButtonText: 'Eliminar').then (result) ->
      if result.value
        swal 'Eliminada', 'Tu rutina a sido borrada', 'success'
      return
    return
  $('.swal2-confirm').click ->
    $(this).closest('tr').slideUp 0
    return
  $('.administrador_add').click ->
    $('#admin_popup').removeClass 'animated bounceOutUp'
    $('#admin_popup').removeAttr 'style'
    $('#admin_popup').show()
    return
  $('#red_button').click ->
    $('#gray_button').attr 'src', 'img/administrador_button_red@2x copy.png'
    return
  $('#divNewNotifications li').on 'click', ->
    $('.dropdown-toggle').html $(this).find('a').html()
    return
  
  $('#cerrar_admi_agregar_ejer').on 'click', ->
    $('#admin_popup').addClass 'animated fadeOutUp'
    return
  $('.btn_cancelar_nuevo_ejer').on 'click', ->
    $('#admin_popup').addClass 'animated fadeOutUp'
    return
  $('.btn_aceptar_nuevo_ejer').on 'click', ->
    $('#admin_popup').addClass 'animated fadeOutUp'
    swal
      type: 'success'
      title: 'Exito'
      text: 'Se ha agregado nuevo Ejercicio'
      allowEscapeKey: true
      allowOutsideClick: true
      confirmButtonText: 'Regresar'
      confirmButtonClass: 'login_sweetalert'
    return
  $('#unpload_image, #label_unpload').click ->
    $('#unpload_image').on 'change', ->
      # Name of file and placeholder
      file = @files[0].name
      dflt = $(this).attr('placeholder')
      document.getElementById('label_unpload').innerHTML = file
      return
    return
  return
