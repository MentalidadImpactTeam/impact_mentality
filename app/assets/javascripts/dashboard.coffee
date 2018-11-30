DashboardController = Paloma.controller('Dashboard')
DashboardController::index = ->
  metodos_menu("ANALITICOS")
  chart = document.getElementById('chart').getContext('2d')
  gradient = chart.createLinearGradient(0, 0, 0, 450)
  gradient.addColorStop 0, 'rgba(255, 0,0, 0.8)'
  gradient.addColorStop 0.5, 'rgba(255, 115, 0, 0.50)'
  gradient.addColorStop 1, 'rgba(255, 115, 0, .30)'
  data = 
    labels: [
      'Etapa 1'
      'Etapa 2'
      'Etapa 3'
      'Etapa 4'
      'Etapa 5'
      'Etapa 6'
      'Etapa 7'
    ]
    datasets: [ {
      label: 'Custom Label Name'
      backgroundColor: gradient
      pointBackgroundColor: 'white'
      borderWidth: 2
      borderColor: 'rgba(255,255,255, 1)'
      data: [
        100
        175
        90
        125
        75
        175
        180
      ]
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
  chartInstance = new Chart(chart,
    type: 'line'
    data: data
    options: options)

DashboardController::player_list = ->
  metodos_menu("LISTA JUGADORES")
  $('.dashboard_jugador').on 'click', -> 
    window.location.href = "/dashboard/" + $(this).closest(".row_hover").data("id")
  $('.profile_jugador').on 'click', -> 
    window.location.href = "/profiles/" + $(this).closest(".row_hover").data("id")
  $('.add_jugadores').on 'click', ->
      swal({
        title: '<strong>Agrega Jugador</strong>',
        type: 'info',
        html: '<input id="agregar_jugador" placeholder="  ID, Nombre, Correo Electrónico">',
        showCloseButton: true,
        showCancelButton: true,
        focusConfirm: true,
        confirmButtonText: 'Agregar',
        confirmButtonAriaLabel: 'Thumbs up, great!',
        cancelButtonText: 'Cancelar'
      })
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
            swal('Exito','La relacion con el jugador a sido eliminada','success')
  

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
    return
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