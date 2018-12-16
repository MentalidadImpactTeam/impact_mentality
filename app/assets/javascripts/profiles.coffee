ProfileController = Paloma.controller('Profiles')
ProfileController::index = ->
  metodos_menu("PERFIL")

  trainings_complete = parseInt($("#sistemas_p_numero").text())
  trainings = parseInt($("#sistemas_p_numerogris").text().replace("/",""))

  porcentage = Math.ceil((trainings_complete / trainings) * 100)

  $("#barra_entrenamientos").width(porcentage + "%");

  $(".sistema_p_imgupload").change ->
    $("form").submit()


  $('#perfil_boton_entrenador').on 'click', ->
    Swal
      title: '<strong>Agrega el Código de tu Entrenador</strong>'
      type: 'info'
      html: '<input id="codigo_entrenador_input" placeholder="Código de entrenador">'
      showCloseButton: true
      showCancelButton: true
      focusConfirm: false
      confirmButtonText: 'Unirme'
      showCancelButton: false,
      cancelButtonAriaLabel: 'Thumbs down'
    return


  $('.sistema_p_editar ').on 'click', (event) ->
    event.preventDefault()
    es = $('#perfil_altura').text();
    pe = $('#perfil_peso').text();
    swal(
      html: '<div> Escribe tu nueva altura </div>' + '<input type="text" id="altura" class="swal2-input" value="' + es + '">' + '<div> Escribe tu nuevo peso </div>' + '<input type="text" id="peso" class="swal2-input" value="' + pe + '">'
      title: 'Modifica tu información'
      inputAttributes: autocapitalize: 'off'
      showCancelButton: true
      confirmButtonText: 'Guardar'
      heightAuto: false
      showCloseButton: true).then (result) ->
        altura1 = document.getElementById('altura').value
        peso1 = document.getElementById('peso').value
        user = $(".hidden_user").val()
        $.ajax
          type: "PATCH"
          url: "/profiles/" + user
          data: height: altura1, weight: peso1
          dataType: "json",
          success: (data) ->
            return
        $('#perfil_altura').text altura1
        $('#perfil_peso').text peso1
        $('.sistema_p_editar').show()
        $('#altura').val altura1
        $('#peso').val peso1
        return
    bodys = document.getElementsByTagName('BODY')
    $(bodys).removeClass 'swal2-height-auto'
    return