chartInstance = ""
page_users = 1
DashboardController = Paloma.controller('Dashboard')
DashboardController::index = ->
  metodos_menu("ANALÍTICOS")
  exercise_graph()
  $("#exercise_graph").change ->
    exercise_graph()

DashboardController::player_list = ->
  metodos_menu("LISTA JUGADORES")
  player_list_table_events()
  $('.add_jugadores').on 'click', ->
      swal({
        title: '<strong>Agrega Jugador</strong>',
        type: 'info',
        html: '<input id="agregar_jugador" placeholder="  ID, Correo Electrónico">',
        showCloseButton: true,
        showCancelButton: true,
        focusConfirm: true,
        heightAuto: false
        confirmButtonText: 'Agregar',
        confirmButtonAriaLabel: 'Thumbs up, great!',
        cancelButtonText: 'Cancelar',
        preConfirm: ->
          new Promise((resolve, reject) ->
            $.ajax
              type: "POST"
              url: "/add_trainer_user"
              data: search_param: $("#agregar_jugador").val()
              dataType: "json",
              success: (data) ->
                resolve(data)
          )
        }).then (response) ->
          if response.value.error
            swal('Alerta','No se encontro el jugador ingresado','warning',"heightAuto: false")
          else if response.value.existe
            swal('Alerta','El jugador ingresado ya fue agregado anteriormente','warning',"heightAuto: false")
          else
            user = response.value
            date = user.created_at.substring(8,10) + "/" + user.created_at.substring(5,7) + "/" + user.created_at.substring(0,4)
            tr = '<tr class="row_hover" data-id="' + user.id + '">
                    <td>
                        <center>
                            <div class="imagen_jugador" style="background-image: url(' + user.user_information.img_url.url + ');"></div>
                        </center>
                    </td>
                    <td>
                        <p class="nombre_jugador">' + user.user_information.name + '</p>
                        <p class="escuela_jugador">Cetys Universidad</p>
                    </td>
                    <td class="columna_eliminada">
                        <p class="correos_jugadores"> ' + user.email + '</p>
                    </td>
                    <td>
                        <p class="posicion_jugadores">' + user.user_information.position + '</p>
                        <p class="deporte_jugadores">' + user.user_information.sport + '</p>
                    </td>
                    <td class="columna_eliminada aliniar_contenido_tabla">5/15 </td>
                    <td class="columna_eliminada aliniar_contenido_tabla">' + date + '</td>
                    <td class="aliniar_contenido_tabla iconos_ajustes_tabla_jugadores">
                        <i class="fas fa-poll dashboard_jugador"></i>
                        <i class="fas fa-adjust profile_jugador"></i>
                        <i class="fas fa-eraser delete_jugador"></i>
                    </td>
                </tr>'
            $(".contenedor_tabla_jugadores tbody").append(tr)
            $('.dashboard_jugador').on 'click', ->
              window.location.href = "/dashboard/" + $(this).closest(".row_hover").data("id")
            $('.profile_jugador').on 'click', ->
              window.location.href = "/profiles/" + $(this).closest(".row_hover").data("id")
            swal('Exito','Se agrego el jugador','success',"heightAuto: false")
  $('.delete_jugador').on 'click', ->
    $row =  $(this).closest(".row_hover")
    swal({
      title: '¿Quieres eliminar la relacion con el jugador?',
      type: 'warning',
      showCancelButton: true,
      background: '#e5e5e5',
      confirmButtonColor: '#fff',
      cancelButtonColor: '#ff1d25',
      cancelButtonText: 'No',
      confirmButtonText: 'Sí',
      heightAuto: false,
      showCloseButton: true,
      preConfirm: ->
        new Promise((resolve, reject) ->
          $.ajax
            type: "POST"
            url: "/delete_trainer_user"
            data: id: $row.data("id")
            dataType: "text",
            success: (data) ->
              resolve(data)
        )
      }).then (response) ->
        if response.value
            $row.remove()
            swal('Exito','La relacion con el jugador a sido eliminada','success','heightAuto: false')
  $('.back_arrow_jugadores, .foward_arrow_jugadores').on 'click', (event) ->
    if $(event.currentTarget).hasClass("foward_arrow_jugadores")
      page_users += 1
    else
      if page_users > 1
        page_users -= 1
    $.ajax
      type: "GET"
      url: "/dashboard/players/page?page=" + page_users
      dataType: "json",
      success: (data) ->
        if data.users.length > 0
          html = ""
          data.users.forEach (value) ->
            # console.log(JSON.parse(value))
            value = JSON.parse(value)
            html += '<tr class="row_hover" data-id="' + value.id + '">
                      <td>
                          <p class="nombre_jugador">' + value.user_information.name + '</p>
                          <p class="escuela_jugador"></p>
                      </td>
                      <td class="columna_eliminada">
                          <p class="correos_jugadores"> ' + value.email + '</p>
                      </td>
                      <td>
                          <p class="posicion_jugadores">' + value.user_information.position + '</p>
                          <p class="deporte_jugadores">' + value.user_information.sport + '</p>
                      </td>
                      <td class="columna_eliminada aliniar_contenido_tabla">25/11/2018</td>
                      <td class="aliniar_contenido_tabla iconos_ajustes_tabla_jugadores">
                          <i class="fas fa-poll dashboard_jugador"></i>
                          <i class="fas fa-user profile_jugador"></i>
                          <i class="fas fa-trash-alt delete_jugador"></i>
                      </td>
                  </tr>'
            $("#tabla_lista_miembros tbody").html(html)
            $(".cantidad_jugadores").text("Se muestran " + data.users.length + " jugadores de " + data.max)
            player_list_table_events()
        else
          if $(event.currentTarget).hasClass("foward_arrow_jugadores")
            page_users -= 1
          else
            page_users += 1
    return
  $(".fa-search").click ->
    if $("#filtro_jugadores").val() == ""
      swal 'Error', 'Favor de ingresar un valor de busqueda.', 'warning'
    else
      $.ajax
        type: "POST"
        url: "/dashboard/search"
        data: search: $("#filtro_jugadores").val()
        dataType: "json",
        success: (data) ->
          if data.users.length == 0
            swal 'Error', 'No se encontraron registros con la busqueda ingresada.', 'warning'
          else
            html = ""
            data.users.forEach (value) ->
              # console.log(JSON.parse(value))
              value = JSON.parse(value)
              html += '<tr class="row_hover" data-id="' + value.id + '">
                        <td>
                            <p class="nombre_jugador">' + value.user_information.name + '</p>
                            <p class="escuela_jugador"></p>
                        </td>
                        <td class="columna_eliminada">
                            <p class="correos_jugadores"> ' + value.email + '</p>
                        </td>
                        <td>
                            <p class="posicion_jugadores">' + value.user_information.position + '</p>
                            <p class="deporte_jugadores">' + value.user_information.sport + '</p>
                        </td>
                        <td class="columna_eliminada aliniar_contenido_tabla">25/11/2018</td>
                        <td class="aliniar_contenido_tabla iconos_ajustes_tabla_jugadores">
                            <i class="fas fa-poll dashboard_jugador"></i>
                            <i class="fas fa-user profile_jugador"></i>
                            <i class="fas fa-trash-alt delete_jugador"></i>
                        </td>
                    </tr>'
            $("#tabla_lista_miembros tbody").html(html)
            $(".cantidad_jugadores").text("Se muestran " + data.users.length + " jugadores de " + data.max)
            player_list_table_events()
          return
      return
    return
exercise_graph = ->
  labels = []
  data_graph = []
  $.ajax
    type: "POST"
    url: "/exercise_graph"
    data: exercise_id: $("#exercise_graph").val()
    dataType: "json",
    success: (data) ->
      if data.results.length > 0
        $(".sistema_db_info_grafica").find("center").next().remove()
        $(".sistema_db_info_grafica").find("center").remove()

        $(".sistema_db_info_tabla").find("center").next().remove()
        $(".sistema_db_info_tabla").find("center").remove()
  
      data.results.forEach (value) ->
        labels.push('Etapa ' + value.stage_id)
        data_graph.push(value.result)

      chart = document.getElementById('chart').getContext('2d')
      gradient = chart.createLinearGradient(0, 0, 0, 450)
      gradient.addColorStop 0, 'rgba(255, 0,0, 0.8)'
      gradient.addColorStop 0.5, 'rgba(255, 115, 0, 0.50)'
      gradient.addColorStop 1, 'rgba(255, 115, 0, .30)'
      data =
        labels: labels
        datasets: [ {
          label: 'Repeticiones'
          backgroundColor: gradient
          pointBackgroundColor: 'white'
          borderWidth: 2
          borderColor: 'rgba(255,255,255, 1)'
          data: data_graph
        } ]
      options =
        responsive: true
        maintainAspectRatio: true
        animation:
          easing: 'easeInOutQuad'
          duration: 800
        scales:
          xAxes: [ { gridLines:
            color: 'rgba(255, 255, 255, 0.08)'
            lineWidth: 2 } ]
          yAxes: [ { gridLines:
            color: 'rgba(255, 255, 255, 0.08)'
            lineWidth: 2 } ]
        elements: line: tension: 0
        legend: display: false
        point: backgroundColor: 'white'
        tooltips:
          titleFontFamily: 'lato'
          backgroundColor: 'rgba(25,25,25,0.5)'
          titleFontColor: 'red'
          caretSize: 8
          cornerRadius: 0
          xPadding: 10
          yPadding: 10

      if chartInstance != ""
        chartInstance.destroy()
      chartInstance = new Chart(chart,
        type: 'line'
        data: data
        options: options)

player_list_table_events = ->
  $('.dashboard_jugador').on 'click', ->
    window.location.href = "/dashboard/" + $(this).closest(".row_hover").data("id")
  $('.profile_jugador').on 'click', ->
    window.location.href = "/profiles/" + $(this).closest(".row_hover").data("id")

@metodos_menu = (titulo) ->
  $(".titulo_mobile_header").text(titulo)
  $('.burger_menu').on 'click', ->
    if $('.sistema_descripcion_menu').hasClass('hide_text_menu')
      $('.sistema_descripcion_menu').removeClass 'display_text_menu'
      $('.menuVertical').removeClass 'reduce_sidecontainer'
      $('.sistema_container').removeClass 'sistema_container_reduce'
      setTimeout (->
        $('.sistema_descripcion_menu').removeClass 'hide_text_menu'
        return
      ), 100
    else
      $('.sistema_descripcion_menu').addClass 'hide_text_menu'
      $('.menuVertical').addClass 'reduce_sidecontainer'
      $('.sistema_container').addClass 'sistema_container_reduce'
      setTimeout (->
        $('.sistema_descripcion_menu').addClass 'display_text_menu'
        $('.menuVertical').addClass 'reduce_sidecontainer'
        $('.sistema_container').addClass 'sistema_container_reduce'
        return
      ), 400

  $('.burger_menu_mobile').on 'click', ->
    if $('#menu_mobile_desplegado').hasClass('desplegado') == false
      $('.burger_menu_mobile').attr 'src', 'img/cancel-music.png'
      $('#menu_mobile_desplegado').addClass 'desplegado'
    else
      $('#menu_mobile_desplegado').removeClass 'desplegado'
      $('.burger_menu_mobile').attr 'src', 'img/hamburger-icon.png'
    return
  $('.sistema_container').on 'mouseenter', ->
    $('#menu_mobile_desplegado').removeClass 'desplegado'
    $('.burger_menu_mobile').attr 'src', 'img/hamburger-icon.png'
    return
