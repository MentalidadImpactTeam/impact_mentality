AdministratorController = Paloma.controller('Administrator/Admin')
AdministratorController::list_users = ->
  $("#menu_usuarios").addClass("admin_active")
  $(".fa-search").click ->
    if $("#filtro_jugadores").val() == ""
      swal 'Error', 'Favor de ingresar un valor de busqueda.', 'warning'
    else
      $.ajax
        type: "POST"
        url: "/administrator/users/search"
        data: search: $("#filtro_jugadores").val()
        dataType: "json",
        success: (data) ->
          if data.users.length == 0
            swal 'Error', 'No se encontraron registros con la busqueda ingresada.', 'warning'
          else
            html = ""
            data.users.forEach (value) ->
              if value.active == 1
                active_class = "usuario_activo"
                status = "ACTIVO"
              else
                active_class = "usuario_inactivo"
                status = "INACTIVO"

              if value.suscription != null
                end_date = value.suscription.end_date.substring(8,10) + "/" + value.suscription.end_date.substring(5,7) + "/" + value.suscription.end_date.substring(0,4)
                intro_date = value.suscription.start_date.substring(8,10) + "/" + value.suscription.start_date.substring(5,7) + "/" + value.suscription.start_date.substring(0,4)
              else
                end_date = ""
                intro_date = ""

              html += '<tr class="row_hover">
                      <input type="hidden" class="hidden_id" value="' + value.id + '">
                      <td>

                          <p class="aliniar_contenido_tabla id_usuario">' + value.information.uid + '</p>
                      </td>
                      <td>
                          <p class="aliniar_contenido_tabla nombre_usuario">' + value.information.name + '</p>
                      </td>

                      <td class="columna_eliminada aliniar_contenido_tabla fecha_cobro">' + end_date + ' </td>
                      <td class="aliniar_contenido_tabla fecha_intro">' + intro_date + '</td>
                      <td class="aliniar_contenido_tabla estado_usuario ' + active_class + '">' + status + '</td>
                      <td class="aliniar_contenido_tabla iconos_ajustes_tabla_jugadores">

                          <label class="switch">
                              <input type="checkbox">
                              <span class="slider round"></span>
                      </label>
                      </td>
                  </tr>'

            $("#admin_tabla_usuarios tbody").html(html)
            $('.row_hover').on 'click', ->
              window.location.href = "/administrator/users/" + $(this).find(".hidden_id").val()
              return

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
          data: id: $(".hidden_user").val(), user: { email: nuevomail }, name: nuevonom
          dataType: "text",
          success: (data) ->
            return
        $('#admin_infoentrenador_nombre').text nuevonom
        $('#admin_correo').text nuevomail
        return
    return
  return

AdministratorController::list_exercises = ->
  $("#menu_ejercicios").addClass("admin_active")
  administrator_exercises_edit()
  $(".adminsearch").click ->
    if $("#filtro_jugadores").val() == ""
      swal 'Error', 'Favor de ingresar un valor de busqueda.', 'warning'
    else
      $.ajax
        type: "POST"
        url: "/administrator/exercises/search"
        data: search: $("#filtro_jugadores").val(), category_id: $('#ul_categories').attr('data-selected')
        dataType: "json",
        success: (data) ->
          if data.exercises.length == 0
            swal 'Error', 'No se encontraron registros con la busqueda ingresada.', 'warning'
          else
            html = ""
            data.exercises.forEach (value) ->
              html += '<tr class="administrador_botones" id="tr_hover" data-exercise="' + value.id + '">
                        <td class="admin_nombre"> ' + value.name + ' </td>
                        <td class="admin_descripcion"> ' + value.description + ' </td>
                        <td>
                          <div class="administrador_botones"> <img src="/img/circulos_icono.png" alt="" width="30px" class="administrador_puntos"></div>
                        </td>
                        <td>
                          <div class="administrador_botones"> <img src="/img/tacha_blanca.png" alt="" class="administrador_tacha"></div>
                        </td>
                      </tr>'
            $(".tabla_ejercicios tbody").html(html)
            $(".administradores_ejercicios_totales").text( data.exercises.length + " EJERCICIOS TOTALES")
            administrator_exercises_edit()
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
    $(".banner_top h1").text("Nuevo Ejercicio")
    $(".btn_aceptar_nuevo_ejer").text("Agregar")
    $("#sistema_admi_nombre_ejercicio_input").val("")
    $("#sistema_admi_descrip_ejercicio_input").val("")
    $("#popup_select_categories").val(1)
    $("#sistema_admin_agregar_ejercicio").attr("data-id", "")
    $('#admin_popup').removeClass 'animated bounceOutUp'
    $('#admin_popup').removeAttr 'style'
    $('#admin_popup').show()
    return
  $('#red_button').click ->
    $('#gray_button').attr 'src', 'img/administrador_button_red@2x copy.png'
    return
  $('#ul_categories li').on 'click', ->
    $('.dropdown-toggle').html $(this).find('p').html()
    $('#ul_categories').attr('data-selected', $(this).find('p').attr('id'))
    administrator_exercises_fill_table($(this).find('p').attr("id"))

    return
  $('#cerrar_admi_agregar_ejer').on 'click', ->
    $('#admin_popup').fadeOut( "slow" );
    return
  $('.btn_cancelar_nuevo_ejer').on 'click', ->
    $('#admin_popup').fadeOut( "slow" );
    return
  $('.btn_aceptar_nuevo_ejer').on 'click', ->
    categoria = $("#popup_select_categories").val()
    nombre = $("#sistema_admi_nombre_ejercicio_input").val()
    descripcion = $("#sistema_admi_descrip_ejercicio_input").val()
    id = $("#sistema_admin_agregar_ejercicio").attr("data-id")
    $('#admin_popup').fadeOut( "slow" );

    $.ajax
      type: "POST"
      url: "/administrator/exercises/edit_exercise"
      data: id: id, name: nombre, description: descripcion, category_id: categoria
      dataType: "text",
      success: (data) ->
        administrator_exercises_fill_table($("#popup_select_categories").val())
        $('#admin_popup').addClass 'animated fadeOutUp'
        swal
          type: 'success'
          title: 'Exito'
          text: 'Se ha editado el ejercicio'
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

administrator_exercises_edit = ->
  $(".administrador_puntos").click ->
    $(".banner_top h1").text("Editar Ejercicio")
    $(".btn_aceptar_nuevo_ejer").text("Editar")
    tr = $(this).closest("tr")
    id = $(tr).data("exercise")
    name = $(tr).find(".admin_nombre").text()
    description = $(tr).find(".admin_descripcion").text()

    $("#sistema_admi_nombre_ejercicio_input").val(name)
    $("#sistema_admi_descrip_ejercicio_input").val(description)
    $("#popup_select_categories").val($('#ul_categories').attr('data-selected'))

    $("#sistema_admin_agregar_ejercicio").attr("data-id", id)

    $('#admin_popup').removeClass 'animated bounceOutUp'
    $('#admin_popup').removeAttr 'style'
    $('#admin_popup').show()

administrator_exercises_fill_table = (category_id) ->
  $.ajax
    type: "GET"
    url: "/administrator/exercises/change_list_exercises"
    data: category_id: category_id
    dataType: "json",
    success: (data) ->
      $("#filtro_jugadores").val("")
      if data.exercises.length > 0
        html = ""
        data.exercises.forEach (value) ->
          html += '<tr id="tr_hover" data-exercise="' + value.id + '">
                    <td class="admin_nombre"> ' + value.name + ' </td>
                    <td class="admin_descripcion"> <textarea> ' + value.description + '</textarea> </td>
                    <td>
                      <div class="administrador_botones"> <img src="/img/circulos_icono.png" alt="" width="30px" class="administrador_puntos"></div>
                    </td>
                    <td>
                      <div class="administrador_botones"> <img src="/img/tacha_blanca.png" alt="" class="administrador_tacha"></div>
                    </td>
                  </tr>'
        $(".tabla_ejercicios tbody").html(html)
        $(".administradores_ejercicios_totales").text( data.exercises.length + " EJERCICIOS TOTALES")
        administrator_exercises_edit()
