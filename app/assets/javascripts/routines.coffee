question_values = ""
RoutinesController = Paloma.controller('Routines')
RoutinesController::index = ->
  metodos_menu("RUTINA")
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
            heightAuto: false
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
            heightAuto: false
            title: 'Favor de ingresar solo valores entre el rango del 1 al 5',
            confirmButtonText: 'Aceptar'
            }).then (response) ->
              if response.value
                window.location.href = "/routines"
      return
    return

  $('.checkmark_rutina').on 'click', ->
    $this = $(this)
    is_test = $this.closest(".sistema_r_ejercicio").find(".hidden_exercise_test").val()
    if is_test == "1"
      swal(
        title: '<strong style="font-family:lato;">Por favor ingresa tu máximo de pruebas</strong>',
        type: 'info',
        html: '<input id="input_pruebas_number" type="number" placeholder="máximo de pruebas"><p id="unidad_prueba">kg</p>',
        showCloseButton: true,
        showCancelButton: true,
        focusConfirm: false,
        confirmButtonText: '<i class="fa fa-thumbs-up"></i> Aceptar',
        confirmButtonAriaLabel: 'Thumbs up, great!',
        ).then (result) ->
          if result.value
            if $("#input_pruebas_number").val() == ""
              swal
                type: 'error'
                title: 'No se introdujo el resultado de la prueba.'
                confirmButtonText: 'Entendido'
                heightAuto: false
            else
              $.ajax
                type: "POST"
                url: "/routines/test_result"
                data: result: $("#input_pruebas_number").val(), exercise_id: $this.closest(".sistema_r_ejercicio").find(".hidden_exercise").val(), routine_exercise_id: $this.closest(".sistema_r_ejercicio").find(".hidden_exercise").data("routine")
                dataType: "text",
                success: (data) ->
                  routines_mark_done($this)
    else
      routines_mark_done($this)
      return
  
  $("#sistema_r_siguientearrow").click ->
    parent = $(this).closest(".sistema_r_contenedorejercicios").find(".active")
    count_exercises = parent.find(".sistema_r_ejercicio").length
    count_exercises_done = parent.find(".ejer_terminado").length
    if count_exercises != count_exercises_done
      swal
        type: 'error'
        heightAuto: false
        title: 'No se puede continuar con la rutina'
        text: 'No se han registrado como terminados todos los ejercicios.'
        confirmButtonText: 'Entendido'
    else
      div_active =  $(".active")
      group = div_active.find(".hidden_group").val()
      group_total = $(".sistema_r_centro").find(".hidden_group").length
      $("#flecha_anterior").addClass("d-flex").show()
      if parseInt(group) == group_total
        $(".sistema_r_centro_der").hide().removeClass("d-flex")

      if group_total == 4
        if group == "1"
          $("#barra_warmup").css("width", "100%")
          $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
          $("#sistema_r_progresonombre").text(" SERIE #1 ")
          $("#sistema_r_siguientefase").text(" SERIE #2 ")
        else if group == "2"
          $("#sistema_r_anteriorfase").text(" SERIE #1 ")
          $("#sistema_r_progresonombre").text(" SERIE #2 ")
          $("#sistema_r_siguientefase").text(" FINISHERS ")
        else if group == "3"
          $("#barra_tricerie").css("width", "100%")
          $("#sistema_r_anteriorfase").text(" SERIE #2 ")
          $("#sistema_r_progresonombre").text(" FINISHERS ")
          $("#sistema_r_siguientefase").text(" DONE ")
        else if group == "4"
          $("#barra_finishers").css("width", "100%")
          $("#sistema_r_anteriorfase").text(" FINISHERS ")
          $("#sistema_r_progresonombre").text(" DONE ")
          $("#rutina_finalizada").css("display", "block")
      else if group_total == 5
        if group == "1"
          $("#barra_warmup").css("width", "100%")
          $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
          $("#sistema_r_progresonombre").text(" SERIE #1 ")
          $("#sistema_r_siguientefase").text(" SERIE #2 ")
        else if group == "2"
          $("#sistema_r_anteriorfase").text(" SERIE #1 ")
          $("#sistema_r_progresonombre").text(" SERIE #2 ")
          $("#sistema_r_siguientefase").text(" SERIE #3 ")
        else if group == "3"
          $("#sistema_r_anteriorfase").text(" SERIE #2 ")
          $("#sistema_r_progresonombre").text(" SERIE #3 ")
          $("#sistema_r_siguientefase").text(" FINISHERS ")
        else if group == "4"
          $("#barra_tricerie").css("width", "100%")
          $("#sistema_r_anteriorfase").text(" SERIE #3 ")
          $("#sistema_r_progresonombre").text(" FINISHERS ")
          $("#sistema_r_siguientefase").text(" DONE ")
        else if group == "5"
          $("#barra_finishers").css("width", "100%")
          $("#sistema_r_anteriorfase").text(" FINISHERS ")
          $("#sistema_r_progresonombre").text(" DONE ")
          $("#rutina_finalizada").css("display", "block")

      div_active.addClass 'animated bounceOutLeft'
      setTimeout (->
        div_active.hide().removeClass("d-flex active")
        div_active.parent().find(".sistema_r_centro input[value=" + (parseInt(group) + 1) + "]").parent().removeAttr("style").removeClass("bounceInLeft animated bounceOutRight").addClass("d-flex bounceInRight animated active")
        $("#flecha_anterior").removeAttr("style")
        if $("#sistema_r_progresonombre").text() == " DONE "
          $("#img_rutina_finalizada").css("display", "block")
          $(".terminado_txt").css("display", "block")
        return
      ), 700
      return
  
  $("#sistema_r_anteriorarrow").click ->
    div_active =  $(".active")
    $("#rutina_finalizada").css("display", "none")
    $("#img_rutina_finalizada").css("display", "none")
    $(".terminado_txt").css("display", "none")
    if div_active.length == 0
      div_active = $(".sistema_r_centro:last")
    group = div_active.find(".hidden_group").val()
    group_total = $(".sistema_r_centro").find(".hidden_group").length
    if group == "2"
      $("#flecha_anterior").removeClass("d-flex").hide()
    else
      $("#flecha_anterior").addClass("d-flex").show()
    if group_total == 4
      if group == "2"
        $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
        $("#sistema_r_progresonombre").text(" WARM UP / PREHABS ")
        $("#sistema_r_siguientefase").text(" SERIE #1 ")
      else if group == "3"
        $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
        $("#sistema_r_progresonombre").text(" SERIE #1 ")
        $("#sistema_r_siguientefase").text(" SERIE #2 ")
      else if group == "4"
        $("#sistema_r_anteriorfase").text(" SERIE #1 ")
        $("#sistema_r_progresonombre").text(" SERIE #2 ")
        $("#sistema_r_siguientefase").text(" FINISHERS ")
        $(".sistema_r_centro_der").removeAttr("style")
      else
        $("#sistema_r_anteriorfase").text(" SERIE #2 ")
        $("#sistema_r_progresonombre").text(" FINISHERS ")
        $("#sistema_r_siguientefase").text(" DONE ")
        $(".sistema_r_centro_der").removeAttr("style")
    else if group_total == 5
      if group == "2"
        $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
        $("#sistema_r_progresonombre").text(" WARM UP / PREHABS ")
        $("#sistema_r_siguientefase").text(" SERIE #1 ")
      else if group == "3"
        $("#sistema_r_anteriorfase").text(" WARM UP / PREHABS ")
        $("#sistema_r_progresonombre").text(" SERIE #1 ")
        $("#sistema_r_siguientefase").text(" SERIE #2 ")
      else if group == "4"
        $("#sistema_r_anteriorfase").text(" SERIE #1 ")
        $("#sistema_r_progresonombre").text(" SERIE #2 ")
        $("#sistema_r_siguientefase").text(" SERIE #3 ")
        $(".sistema_r_centro_der").removeAttr("style")
      else
        $("#sistema_r_anteriorfase").text(" SERIE #2 ")
        $("#sistema_r_progresonombre").text(" SERIE #3 ")
        $("#sistema_r_siguientefase").text(" FINISHERS ")
        $(".sistema_r_centro_der").removeAttr("style")

    if $(".active").length > 0
      div_active.addClass 'animated bounceOutRight'
      setTimeout (->
        div_active.hide().removeClass("d-flex active")
        div_active.parent().find(".sistema_r_centro input[value=" + (parseInt(group) - 1) + "]").parent().removeAttr("style").removeClass("bounceInRight animated bounceOutLeft").addClass("d-flex bounceInLeft animated active")
        if group != "2"
          $("#flecha_anterior").removeAttr("style")
        return
      ), 700
    else
      div_active.hide().removeClass("d-flex active")
      div_active.parent().find(".sistema_r_centro input[value=" + (parseInt(group) - 1) + "]").parent().removeAttr("style").removeClass("bounceInRight animated bounceOutLeft").addClass("d-flex bounceInLeft animated active")
      if group != "2"
        $("#flecha_anterior").removeAttr("style")

  $(".sistema_r_cambiaricono").click ->
    $(".tabla_ejercicios tbody").html("")
    $(".sistema_contenido").css("overflow","hidden");
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
              <td colspan='2'>" + data[hash]["description"] + "</td>
          </tr>"
        $(".tabla_ejercicios tbody").html(tbody)
        $("#sistema_rutina_cambio_table").css("display","flex");
        $(".tabla_ejercicios tbody tr").click ->
          $this = $(this)
          swal({
            title: '¿Quieres este ejercicio?',
            heightAuto: false,
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
                swal('Exito','Tu rutina ha sido modificada','heightAuto: false','success',$("#sistema_rutina_cambio_table").css("display","none"))


routines_mark_done = ($this) ->
  $this.parents('.sistema_r_ejercicio').addClass 'ejer_terminado'
  $this.css 'display', 'none'

  parent = $this.closest(".sistema_r_centro")
  count_exercises = parent.find(".sistema_r_ejercicio").length
  count_exercises_done = parent.find(".ejer_terminado").length

  if count_exercises == 2
    porcentage = 50 * count_exercises_done
  else if count_exercises == 3
    porcentage = 33 * count_exercises_done
  else if count_exercises == 4
    porcentage = 25 * count_exercises_done

  div_active =  $(".active")
  group = div_active.find(".hidden_group").val()
  group_total = $(".sistema_r_centro").find(".hidden_group").length
  if group_total == 4
    if group == "1"
      $("#barra_warmup").css("width", porcentage + "%")
    else if group == "2"
      group_2_exercises_count = $(".hidden_group[value=2]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      group_3_exercises_count = $(".hidden_group[value=3]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      total_exercises = group_2_exercises_count + group_3_exercises_count
      porcentage = Math.ceil(100 / total_exercises) * count_exercises_done
      $("#barra_tricerie").css("width", porcentage + "%")
    else if group == "3"
      group_2_exercises_count = $(".hidden_group[value=2]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      group_3_exercises_count = $(".hidden_group[value=3]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      total_exercises = group_2_exercises_count + group_3_exercises_count
      total_exercises_done = group_2_exercises_count + count_exercises_done
      porcentage = Math.ceil(100 / total_exercises) * total_exercises_done
      porcentage = 100 if porcentage > 100
      $("#barra_tricerie").css("width", porcentage + "%")
    else
      $("#barra_finishers").css("width", porcentage + "%")

  else if group_total == 5
    if group == "1"
      $("#barra_warmup").css("width", porcentage + "%")
    else if group == "2"
      group_2_exercises_count = $(".hidden_group[value=2]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      porcentage = parseInt(porcentage / group_2_exercises_count)
      $("#barra_tricerie").css("width", porcentage + "%")
    else if group == "3"
      group_2_exercises_count = $(".hidden_group[value=2]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      group_3_exercises_count = $(".hidden_group[value=3]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      total_exercises = group_2_exercises_count + group_3_exercises_count
      total_exercises_done = group_2_exercises_count + count_exercises_done
      porcentage = Math.ceil(66 / total_exercises) * total_exercises_done
      $("#barra_tricerie").css("width", porcentage + "%")
    else if group == "4"
      group_2_exercises_count = $(".hidden_group[value=2]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      group_3_exercises_count = $(".hidden_group[value=3]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      group_4_exercises_count = $(".hidden_group[value=4]").closest(".sistema_r_centro").find(".sistema_r_ejercicio").length
      total_exercises = group_2_exercises_count + group_3_exercises_count + group_4_exercises_count
      total_exercises_done = group_2_exercises_count + group_3_exercises_count + count_exercises_done
      porcentage = Math.ceil(100 / total_exercises) * total_exercises_done
      porcentage = 100 if porcentage > 100
      $("#barra_tricerie").css("width", porcentage + "%")
    else
      $("#barra_finishers").css("width", porcentage + "%")
  
  $.ajax
    type: "POST"
    url: "/routines/mark_exercise_done"
    data: id: $this.closest(".sistema_r_ejercicio").find(".hidden_exercise").data("routine")
    dataType: "text",
    success: (data) ->
      return