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
            html = html + "<tr style='border-bottom: 1px solid black;'><td style='width: 200px;'>" + data[hash].category + "</td>
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
            html = html + "<tr style='border-bottom: 1px solid black;'><td style='width: 200px;'>" + data[hash].category + "</td>
                    <td style='width: 200px;'>" + data[hash].subcategory + "</td>
                    <td>" + data[hash].exercise_cat + "</td>
                    <td>" + data[hash].exercise + "</td></tr>"
          $("#tabla_ejercicios tbody").html(html)