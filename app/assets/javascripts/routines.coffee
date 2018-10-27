question_values = ""
RoutinesController = Paloma.controller('Routines')
RoutinesController::index = ->
  if $(".hidden_modal").val() == "true"
    swal.mixin(
      input: 'number'
      customClass: 'questionario_modal'
      confirmButtonText: 'Siguiente'
      showCancelButton: false
      progressSteps: [
        '1'
        '2'
        '3'
      ]).queue([
      {
        title: '¿Qué tan cansado estas?'
        text: 'Ingresar un valor del 1 al 5'
      }
      '¿Qué tan bueno es tu estado de animo?'
      '¿Cuál es tu nivel de estrés ?'
    ]).then (result) ->
      if result.value
        correct_value = true
        result.value.forEach (value) ->
          if value == 0 or value > 5
            correct_value = false
        if correct_value
          question_values = result.value
          swal({
            title: 'Tu rutina a sido generada!',
            confirmButtonText: 'Listo para tu rutina!',
            preConfirm: (result) ->
              new Promise((resolve, reject) ->
                $.ajax
                  type: "POST"
                  url: "/routines"
                  data: values: question_values
                  dataType: "text",
                  success: (data) ->
                    resolve(data)
                    console.log(data)
                  error: (e) ->
                    console.log(e)
                return
              )
            }).then (response) ->
              if response.value
                window.location.href = "/routines"
        else
          swal({
            title: 'Favor de ingresar solo valores entre el rango del 1 al 5',
            confirmButtonText: 'Aceptar'
            }).then (response) ->
              if response.value
                window.location.href = "/routines"
      return
    return

  $("#sistema_r_siguientearrow").click ->
    div_active =  $(".active")
    group = div_active.find(".hidden_group").val()
    group_total = $(".sistema_r_centro_iz").find(".hidden_group").length
    $("#flecha_anterior").addClass("d-flex").show()
    if parseInt(group) == group_total
      $(".sistema_r_centro_der").hide().removeClass("d-flex")

    if group_total == 4
      if group == "1"
        $("#barra_warmup").css("width", "100%")
        $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
        $("#sistema_r_progresonombre").text(" TRICERIE #1 ")
        $("#sistema_r_siguientefase").text(" TRICERIE #2 ")
      else if group == "2"
        $("#barra_tricerie").css("width", "50%")
        $("#sistema_r_anteriorfase").text(" TRICERIE #1 ")
        $("#sistema_r_progresonombre").text(" TRICERIE #2 ")
        $("#sistema_r_siguientefase").text(" TRICERIE #3 ")
      else if group == "3"
        $("#barra_tricerie").css("width", "100%")
        $("#sistema_r_anteriorfase").text(" TRICERIE #2 ")
        $("#sistema_r_progresonombre").text(" TRICERIE #3 ")
        $("#sistema_r_siguientefase").text(" DONE ")
      else if group == "4"
        $("#barra_finishers").css("width", "100%")
        $("#sistema_r_anteriorfase").text(" FINISHERS ")
        $("#sistema_r_progresonombre").text(" DONE ")
    else if group_total == 5
      if group == "1"
        $("#barra_warmup").css("width", "100%")
        $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
        $("#sistema_r_progresonombre").text(" TRICERIE #1 ")
        $("#sistema_r_siguientefase").text(" TRICERIE #2 ")
      else if group == "2"
        $("#barra_tricerie").css("width", "33%")
        $("#sistema_r_anteriorfase").text(" TRICERIE #1 ")
        $("#sistema_r_progresonombre").text(" TRICERIE #2 ")
        $("#sistema_r_siguientefase").text(" TRICERIE #3 ")
      else if group == "3"
        $("#barra_tricerie").css("width", "66%")
        $("#sistema_r_anteriorfase").text(" TRICERIE #2 ")
        $("#sistema_r_progresonombre").text(" TRICERIE #3 ")
        $("#sistema_r_siguientefase").text(" FINISHERS ")
      else if group == "4"
        $("#barra_tricerie").css("width", "100%")
        $("#sistema_r_anteriorfase").text(" TRICERIE #3 ")
        $("#sistema_r_progresonombre").text(" FINISHERS ")
        $("#sistema_r_siguientefase").text(" DONE ")
      else if group == "5"
        $("#barra_finishers").css("width", "100%")
        $("#sistema_r_anteriorfase").text(" FINISHERS ")
        $("#sistema_r_progresonombre").text(" DONE ")

    div_active.addClass 'animated bounceOutLeft'
    setTimeout (->
      div_active.hide().removeClass("d-flex active")
      div_active.parent().find(".sistema_r_centro_iz input[value=" + (parseInt(group) + 1) + "]").parent().removeAttr("style").removeClass("bounceInLeft animated bounceOutRight").addClass("d-flex bounceInRight animated active")
      $("#flecha_anterior").removeAttr("style")
      return
    ), 700
  
  $("#sistema_r_anteriorarrow").click ->
    div_active =  $(".active")
    if div_active.length == 0
      div_active = $(".sistema_r_centro_iz:last")
    group = div_active.find(".hidden_group").val()
    group_total = $(".sistema_r_centro_iz").find(".hidden_group").length
    if group == "2"
      $("#flecha_anterior").removeClass("d-flex").hide()
    else
      $("#flecha_anterior").addClass("d-flex").show()
    if group_total == 4
      if group == "2"
        $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
        $("#sistema_r_progresonombre").text(" WARM UP / PREHABS ")
        $("#sistema_r_siguientefase").text(" TRICERIE #1 ")
      else if group == "3"
        $("#sistema_r_anteriorfase").text(" TRICERIE #1 ")
        $("#sistema_r_progresonombre").text(" TRICERIE #2 ")
        $("#sistema_r_siguientefase").text(" DONE ")
      else if group == "4"
        $("#sistema_r_anteriorfase").text(" FINISHERS ")
    else if group_total == 5
      if group == "2"
        $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
        $("#sistema_r_progresonombre").text(" WARM UP / PREHABS ")
        $("#sistema_r_siguientefase").text(" TRICERIE #1 ")
      else if group == "3"
        $("#sistema_r_anteriorfase").text(" TRICERIE #1 ")
        $("#sistema_r_progresonombre").text(" TRICERIE #2 ")
        $("#sistema_r_siguientefase").text(" TRICERIE #3 ")
      else if group == "4"
        $("#sistema_r_anteriorfase").text(" TRICERIE #2 ")
        $("#sistema_r_progresonombre").text(" TRICERIE #3 ")
        $("#sistema_r_siguientefase").text(" FINISHERS ")
      else
        $("#sistema_r_anteriorfase").text(" TRICERIE #3 ")
        $("#sistema_r_progresonombre").text(" FINISHERS ")
        $("#sistema_r_siguientefase").text(" DONE ")

    if $(".active").length > 0
      div_active.addClass 'animated bounceOutRight'
      setTimeout (->
        div_active.hide().removeClass("d-flex active")
        div_active.parent().find(".sistema_r_centro_iz input[value=" + (parseInt(group) - 1) + "]").parent().removeAttr("style").removeClass("bounceInRight animated bounceOutLeft").addClass("d-flex bounceInLeft animated active")
        if group != "2"
          $("#flecha_anterior").removeAttr("style")
        return
      ), 700
    else
      div_active.hide().removeClass("d-flex active")
      div_active.parent().find(".sistema_r_centro_iz input[value=" + (parseInt(group) - 1) + "]").parent().removeAttr("style").removeClass("bounceInRight animated bounceOutLeft").addClass("d-flex bounceInLeft animated active")
      if group != "2"
        $("#flecha_anterior").removeAttr("style")

  $(".sistema_r_cambiaricono").click ->
    $(".tabla_ejercicios tbody").html("")
    exercise_id = $(this).closest(".sistema_r_ejercicio").find(".hidden_exercise").val()
    routine_id = $(this).closest(".sistema_r_ejercicio").find(".hidden_exercise").attr("data-routine")
    $(this).closest(".sistema_r_ejercicio").addClass("change")
    $.ajax
      type: "POST"
      url: "/routines/list_exercises"
      data: exercise_id: exercise_id
      dataType: "json",
      success: (data) ->
        tbody = ""
        $(".tabla_ejercicios").attr("data-category", data[0]["category_id"]).attr("data-routine", routine_id)
        $(data).each (hash) ->
          tbody += "<tr id='tr_hover' data-exercise='" + data[hash]["id"] + "'>
              <td> " + data[hash]["name"] + " </td>
              <td> 3 sets de 15 repeticiones </td>
              <td colspan='2'>Lorem itsum rem its ate m arem itsum rem its atesom arem itsum rem its atesom arem itsum rem its atesom arem itsum rem its atesom arem itsum rem its atesom ausom au</td>
          </tr>"
        $(".tabla_ejercicios tbody").html(tbody)
        $("#sistema_rutina_cambio_table").css("display","flex");
        $(".tabla_ejercicios tbody tr").click ->
          $this = $(this)
          swal({
            title: '¿Quieres este ejercicio?',
            text: "El ejercicio elegido reemplazará al ejercicio original",
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
                  url: "/routines/change_exercise"
                  data: exercise_id: $this.attr("data-exercise"), routine_id: $(".tabla_ejercicios").attr("data-routine")
                  dataType: "json",
                  success: (data) ->
                    $(".sistema_r_ejercicio.change").find(".sistema_r_tipoejercicio div:first").text($this.find("td:first").text())
                    $(".sistema_r_ejercicio.change").removeClass("change").find(".hidden_exercise").val($this.attr("data-exercise"))
                    resolve(data)
                    console.log(data)
                  error: (e) ->
                    console.log(e)
                return
              )
            }).then (response) ->
              if response.value
                swal('Exito','Tu rutina ha sido modificada','success',$("#sistema_rutina_cambio_table").css("display","none"))
            
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
