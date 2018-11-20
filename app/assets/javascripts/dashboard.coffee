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