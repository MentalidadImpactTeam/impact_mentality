HomeController = Paloma.controller('Home')
HomeController::index = ->
  $("#dias, #etapas").change ->
    if $("#dias").val() != "0"
      etapa = $("#etapas").val()
      dia = $("#dias").val()

      $.ajax
        type: "POST"
        url: "/rutinas"
        data: stage_id: etapa, day: dia
        dataType: "json",
        success: (data) ->
          html = ""
          $(data).each (hash) ->
            html = html + "<tr style='border-bottom: 1px solid black; background-color: white;'><td style='width: 200px;'>" + data[hash].category + "</td>
                    <td style='width: 200px;'>" + data[hash].subcategory + "</td>
                    <td style='width: 300px;'>" + data[hash].exercise_cat + "</td>
                    <td>" + data[hash].exercise + "</td></tr>"
          $("#tabla_ejercicios tbody").html(html)
  
  $("#button").click ->
    if $("#dias").val() != "0"
      etapa = $("#etapas").val()
      dia = $("#dias").val()

      $.ajax
        type: "POST"
        url: "/rutinas"
        data: stage_id: etapa, day: dia
        dataType: "json",
        success: (data) ->
          html = ""
          $(data).each (hash) ->
            html = html + "<tr style='border-bottom: 1px solid black; background-color: white;'><td style='width: 200px;'>" + data[hash].category + "</td>
                    <td style='width: 200px;'>" + data[hash].subcategory + "</td>
                    <td>" + data[hash].exercise_cat + "</td>
                    <td>" + data[hash].exercise + "</td></tr>"
          $("#tabla_ejercicios tbody").html(html)
  
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