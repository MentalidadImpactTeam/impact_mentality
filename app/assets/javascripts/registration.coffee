kg_var = 0
Conekta.setPublicKey("key_HcFQfz7edHvGnSxP8cettSA");

RegistrationController = Paloma.controller('Users/Registrations')
RegistrationController::new = ->
  eventos_registro()
  eventos_tipos_usuarios()
  eventos_datos_personales()
  eventos_datos_deportivos()
  eventos_metas_objetivos()
  eventos_forma_pago()
  eventos_planes()
  eventos_entrenador()

  #END OF CLICK EVENT REGISTRO BTN
  $('#registro_close').on 'click', ->
    $('#registro_modal').addClass 'animated bounceOut'
    return

  $('#DP_close').on 'click', ->
    $('#DP_modal').addClass 'animated bounceOut'
    return

  $('#IDep_close').on 'click', ->
    $('#IDep_modal').addClass 'animated bounceOut'
    return

eventos_registro = ->
  $('#user_email, #user_password, #user_password_confirmation').on 'keyup', ->
    $(this).removeClass 'input_error'
    return

  $('#registro_btn').on 'click', (e) ->
    if $("#checkbox_terminos").prop("checked") == false
      Swal.fire
        type: 'error',
        title: 'Aviso',
        text: 'Debes aceptar nuestros terminos y condiciones para poder registrarte',
        heightAuto:false
      return false
    if $('#user_email').val() == ''
      registro_correoval = 1
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese su Correo Electrónico'
        allowEscapeKey: true
        allowOutsideClick: true
        heightAuto: false
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'registro_sweetalert'
      $('#user_email').addClass 'input_error'
      return false
    re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if !re.test(String($('#user_email').val()).toLowerCase())
      registro_correoval = 1
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese un Correo Electrónico Valido'
        allowEscapeKey: true
        allowOutsideClick: true
        heightAuto: false
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'registro_sweetalert'
      $('#user_email').addClass 'input_error'
      return false
    if $('#user_password').val() == ''
      registro_contval = 1
      swal
        type: 'error'
        title: 'Alerta'
        heightAuto: false
        text: 'Por favor Ingrese su Contraseña'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'registro_sweetalert'
      $('#user_password').addClass 'input_error'
      return false
    if $('#user_password').val().length < 6
      registro_contval = 1
      swal
        type: 'error'
        heightAuto: false
        title: 'Alerta'
        text: 'Por favor Ingrese Una Contraseña Con Al Menos 6 Caracteres'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'registro_sweetalert'
      $('#user_password').addClass 'input_error'
      return false
    if $('#user_password').val() != $('#user_password_confirmation').val()
      swal
        type: 'error'
        title: 'Alerta'
        heightAuto: false
        text: 'Las Contraseñas no son complatibles.'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'registro_sweetalert'
      $('#user_password, #user_password_confirmation').addClass 'input_error'
      return false
    if $('#user_email').val() != ''
      $.ajax
        type: "POST"
        url: "/checkuser"
        data: username: $('#user_email').val()
        dataType: "json",
        success: (data) ->
          if data.existe
            swal
              type: 'error'
              heightAuto: false
              title: 'Alerta'
              text: 'El usuario ya existe.'
              allowEscapeKey: true
              allowOutsideClick: true
              confirmButtonText: 'Regresar'
              confirmButtonClass: 'login_sweetalert'
            $('.user_email').addClass 'input_error'
            return false
          else
            if $('#user_email').val() != ''
              if $('#user_email').val() != ''
                $('#registro_modal').addClass 'animated bounceOutUp'
                setTimeout (->
                  $("#contenedor_registro").css('display','none')
                  # $("#div_datos_personales").removeAttr("style")
                  $("#div_tipo_usuario").removeAttr("style")
                  return
                ), 800
      return false
    return

eventos_tipos_usuarios = ->
  validacion_usuario = false
  validacion_entrenador = false
  validacion_escuela = false
  $('#TU_entrenador, #TU_escuela, #TU_usuario').mouseover ->
    $(this).addClass 'tipo_hover'
    $(this).find('i').addClass 'tipo_unhover'
    $(this).find('h5').addClass 'tipo_unhover'
    return
  $('#TU_entrenador, #TU_escuela, #TU_usuario').mouseout ->
    $(this).removeClass 'tipo_hover'
    $(this).find('i').removeClass 'tipo_unhover'
    $(this).find('h5').removeClass 'tipo_unhover'
    return

  ### ELECCION ENTRENADOR ###

  $('#TU_entrenador').on 'click', ->
    $(this).addClass 'animated pulse'
    $(this).addClass 'tipo_seleccionado'
    $(this).find('i').addClass 'deseleccion'
    $(this).find('h5').addClass 'deseleccion'
    $('#TU_escuela, #TU_usuario').removeClass 'tipo_seleccionado animated pulse'
    $('#TU_escuela i, #TU_escuela h5, #TU_usuario i, #TU_usuario h5').removeClass 'tipo_seleccionado, deseleccion'
    $('#TU_btn').show 500
    $('#registro_trainer_code').hide 500
    $('#registro_trainer_code input').val("")
    validacion_entrenador = true
    validacion_escuela = false
    validacion_usuario = false
    return

  ### ELECCION ESCUELA ###

  $('#TU_escuela').on 'click', ->
    $(this).addClass 'animated pulse'
    $(this).addClass 'tipo_seleccionado'
    $(this).find('i').addClass 'deseleccion'
    $(this).find('h5').addClass 'deseleccion'
    $('#TU_entrenador, #TU_usuario').removeClass 'tipo_seleccionado animated pulse'
    $('#TU_entrenador i, #TU_entrenador h5, #TU_usuario i, #TU_usuario h5').removeClass 'tipo_seleccionado, deseleccion'
    $('#TU_btn').show 500
    $('#registro_trainer_code').hide 500
    $('#registro_trainer_code input').val("")
    validacion_escuela = true
    validacion_entrenador = false
    validacion_usuario = false
    return

  ### ELECCION USUARIO ###

  $('#TU_usuario').on 'click', ->
    $(this).addClass 'animated pulse'
    $(this).addClass 'tipo_seleccionado'
    $(this).find('i').addClass 'deseleccion'
    $(this).find('h5').addClass 'deseleccion'
    $('#TU_entrenador, #TU_escuela').removeClass 'tipo_seleccionado animated pulse'
    $('#TU_entrenador i, #TU_entrenador h5, #TU_escuela i, #TU_escuela h5').removeClass 'tipo_seleccionado, deseleccion'
    $('#TU_btn').show 500
    $('#registro_trainer_code').show 500
    validacion_usuario = true
    validacion_escuela = false
    validacion_entrenador = false
    return
  $('#TU_btn').on 'click', ->
    if $('#registro_trainer_code input').val() != ""
      $.ajax
        type: "POST"
        url: "/checktrainercode"
        data: trainer: $('#registro_trainer_code input').val()
        dataType: "json",
        success: (data) ->
          if data.error
            swal
              type: 'error'
              heightAuto: false
              title: 'Alerta'
              text: data.mensaje
              allowEscapeKey: true
              allowOutsideClick: true
              confirmButtonText: 'Regresar'
              confirmButtonClass: 'login_sweetalert'
          else
            if data.influencer
              $("#influencer_code").val($('#registro_trainer_code input').val())
              $("#row_influencer").removeAttr("style")
              $("#row_influencer .PP_subtitulo").text("Descuento de 15% por codigo: " + $("#influencer_code").val())

              $(".PP_mensual").text("$127.50 MXN")
              $(".PP_trimestral").text("$306 MXN")
              $(".PP_anual").text("$1241 MXN")

            eventos_btn_tipos_usuarios(validacion_usuario,validacion_entrenador,validacion_escuela)
          return false
      return false
    else
      eventos_btn_tipos_usuarios(validacion_usuario,validacion_entrenador,validacion_escuela)
    return false

eventos_datos_personales = ->
  $('#IP_nombre').on 'click', ->
    $('#input_box_nombre').removeClass 'input_error'
    return
  $('#IP_apellido').on 'click', ->
    $('#input_box_apellido').removeClass 'input_error'
    return
  $('#IP_Experiencia').on 'click', ->
    $('#input_box_exp').removeClass 'input_error'
    return
  $('#IP_genero').on 'click', ->
    $('#input_box_gen').removeClass 'input_error'
    return
  $('#IP_peso').on 'click', ->
    $('#input_box_peso').removeClass 'input_error'
    return
  $('#IP_Estatura').on 'click', ->
    $('#input_box_estatura').removeClass 'input_error'
    return

  $('#IP_peso').on 'click', ->
    $('#IP_peso').val ''
    kg_var = 0
    return

  $('#IP_peso').on 'blur', ->
    if $('#IP_peso').val() != ''
      if kg_var == 0
        addkg()
    return

  $('#IP_btn').on 'click', (e) ->
    if $('#IP_nombre').val() == ''
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese su Nombre'
        allowEscapeKey: true
        heightAuto: false
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('#input_box_nombre').addClass 'input_error'
      return false
    else
      $('#input_box_nombre').removeClass 'input_error'
      if $('#IP_apellido').val() == ''
        swal
          type: 'error'
          title: 'Alerta'
          text: 'Por favor Ingrese su Apellido'
          heightAuto: false
          allowEscapeKey: true
          allowOutsideClick: true
          confirmButtonText: 'Regresar'
          confirmButtonClass: 'login_sweetalert'
        $('#input_box_apellido').addClass 'input_error'
        return false
      else
        $('#input_box_apellido').removeClass 'input_error'
        if $('#IP_telefono').val() == ''
          swal
            type: 'error'
            title: 'Alerta'
            text: 'Por favor Ingrese su Telefono'
            allowEscapeKey: true
            heightAuto: false
            allowOutsideClick: true
            confirmButtonText: 'Regresar'
            confirmButtonClass: 'login_sweetalert'
          $('#input_box_telefono').addClass 'input_error'
          return false
        else
          $('#input_box_telefono').removeClass 'input_error'
          if $('#IP_fecha_nacimiento').val() == ''
            swal
              type: 'error'
              title: 'Alerta'
              heightAuto: false
              text: 'Por favor Ingrese su Fecha de Nacimiento'
              allowEscapeKey: true
              allowOutsideClick: true
              confirmButtonText: 'Regresar'
              confirmButtonClass: 'login_sweetalert'
            $('#input_box_fecha_nacimiento').addClass 'input_error'
            return false
          else
            $('#input_box_fecha_nacimiento').removeClass 'input_error'
            if $('#IP_Experiencia').val() == ''
              swal
                type: 'error'
                title: 'Alerta'
                heightAuto: false
                text: 'Por favor Ingrese su Experiencia'
                allowEscapeKey: true
                allowOutsideClick: true
                confirmButtonText: 'Regresar'
                confirmButtonClass: 'login_sweetalert'
              $('#input_box_exp').addClass 'input_error'
              return false
            else
                  if $('#IP_Estatura').val() == ''
                    swal
                      type: 'error'
                      title: 'Alerta'
                      text: 'Por favor Ingrese su Estatura'
                      heightAuto: false
                      allowEscapeKey: true
                      allowOutsideClick: true
                      confirmButtonText: 'Regresar'
                      confirmButtonClass: 'login_sweetalert'
                    $('#input_box_estatura').addClass 'input_error'
                    return false
                  else
                    $('#input_box_estatura').removeClass 'input_error'
                    $('#div_datos_personales').addClass 'animated bounceOutLeft'
                    setTimeout (->
                      $("#div_datos_personales").css('display','none')
                      $("#div_informacion_deportiva").removeAttr("style")
                      return
                    ), 500
    return false

eventos_datos_deportivos = ->
  $('#ID_exp').on 'click', ->
    $('.input_box_exp').removeClass 'input_error'
    return
  $('#ID_deporte').on 'click', ->
    $('#input_box_deporte').removeClass 'input_error'
    return
  $('#ID_btn').on 'click', ->
    if $('#ID_deporte').val() == ''
      swal
        type: 'error'
        heightAuto: false
        title: 'Alerta'
        text: 'Por favor Ingrese su Deporte'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('#input_box_deporte').addClass 'input_error'
      return false
    else
      if $('#ID_pos_obj').val() == ''
        swal
          type: 'error'
          heightAuto: false
          title: 'Alerta'
          text: 'Por favor Ingrese su Posicion'
          allowEscapeKey: true
          allowOutsideClick: true
          confirmButtonText: 'Regresar'
          confirmButtonClass: 'login_sweetalert'
        $('#input_box_p').addClass 'input_error'
        return false
      else
          if $('#ID_exp').val() == ''
            swal
              type: 'error'
              title: 'Alerta'
              heightAuto: false
              text: 'Por favor Ingrese su Experiencia'
              allowEscapeKey: true
              allowOutsideClick: true
              confirmButtonText: 'Regresar'
              confirmButtonClass: 'login_sweetalert'
            $('.input_box_exp').addClass 'input_error'
            return false
          else
            $('#div_informacion_deportiva').addClass 'animated bounceOutLeft'
            setTimeout (->
              $("#div_informacion_deportiva").css('display','none')
              $("#div_metas_objetivos").removeAttr("style")
              return
            ), 500
    return false
  FootballA = '<option value="skill">Skill</option><option value="linea">Linea</option><option value="pateador">Pateador</option><option value="Mariscal">Mariscal de campo</option>'
  Basket = '<option value="poste">Poste</option><option value="botador">Botador-Ala</option>'
  beisbol = '<option value="field">Infield/Outfield</option><option value="Pitcher">Pitcher</option>'
  soccer = '<option value="Campo">Campo</option><option value="Portero">Portero</option>'
  hockey = ''
  hockeyPasto = ''
  atletismo = '<option value="Distancia">Distancia</option><option value="Salto">Salto</option><option value="Velocidad">Velocidad</option><option value="Lanzamiento">Lanzamiento</option>'
  golf = ''
  tennis = ''
  crossCountry = ''
  combate = ''
  rugby = '<option value="Delantero">Delantero</option><option value="Back">Back</option>'
  lacrosse = '<option value="Portero">Portero</option><option value="Campo">Campo</option>'
  natacion = '<option value="Distancia">Distancia</option><option value="Velocidad">Velocidad</option>'
  voleibol = ''
  luchaolim = ''
  porrasbaile = ''
  ciclismo = ''
  maraton = ''
  correr = ''
  handball = ''
  obstaculoscarrera = ''
  waterpolo = ''
  desaparece = 0
  $('#ID_deporte').on 'change', ->
    if $('#ID_deporte').val() == 'Futbol'
      $('#ID_pos_obj').empty()
      $('#ID_pos_obj').append FootballA
      desaparece = 1
    else
      desaparece = 0
      if $('#ID_deporte').val() == 'Balocensto'
        $('#ID_pos_obj').empty()
        $('#ID_pos_obj').append Basket
        desaparece = 1
      else
        desaparece = 0
        if $('#ID_deporte').val() == 'Beisbol'
          $('#ID_pos_obj').empty()
          $('#ID_pos_obj').append beisbol
          desaparece = 1
        else
          desaparece = 0
          if $('#ID_deporte').val() == 'Soccer'
            $('#ID_pos_obj').empty()
            $('#ID_pos_obj').append soccer
            desaparece = 1
          else
            desaparece = 0
            if $('#ID_deporte').val() == 'Atletismo'
              $('#ID_pos_obj').empty()
              $('#ID_pos_obj').append atletismo
              desaparece = 1
            else
              desaparece = 0
              if $('#ID_deporte').val() == 'Rugby'
                $('#ID_pos_obj').empty()
                $('#ID_pos_obj').append rugby
                desaparece = 1
              else
                desaparece = 0
                if $('#ID_deporte').val() == 'Lacrosse'
                  $('#ID_pos_obj').empty()
                  $('#ID_pos_obj').append lacrosse
                  desaparece = 1
                else
                  desaparece = 0
                  if $('#ID_deporte').val() == 'Natación'
                    $('#ID_pos_obj').empty()
                    $('#ID_pos_obj').append natacion
                    desaparece = 1
    if desaparece == 0
      $('.input_box_p').removeClass 'bounceIn'
      $('.input_box_p').addClass 'bounceOut'
    else
      $('.input_box_p').addClass 'bounceIn'
      $('.input_box_p').removeClass 'bounceOut'
    return

    $('.IDep_deporte_box').on 'click', ->
      $('.IDep_deporte_box').removeClass 'input_error'
      return
    $('.IDep_posicion_box').on 'click', ->
      $('.IDep_posicion_box').removeClass 'input_error'
      return
    $('.IDep_lesion_box').on 'click', ->
      $('.IDep_lesion_box').removeClass 'input_error'
      return
    $('.IDep_exp_box').on 'click', ->
      $('.IDep_exp_box').removeClass 'input_error'
      return

  $('#IDep_btn').on 'click', ->
    IDep_sport = '0'
    IDep_experience = '0'
    IDep_posicion = '0'
    IDep_lesiones = '0'
    #FUNCIONES DE VERIFICACION

    if $('#user_user_information_attributes_sport').val() == ''
      swal
        type: 'error'
        heightAuto: false
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.IDep_deporte_box').addClass 'input_error'
      IDep_sport = '0'
      return false
    else
      IDep_sport = '1'
    if $('#user_user_information_attributes_experience').val() == ''
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        heightAuto: false
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.IDep_exp_box').addClass 'input_error'
      IDep_experience = '0'
      return false
    else
      IDep_experience = '1'
    if $('#user_user_information_attributes_position').val() == ''
      swal
        type: 'error'
        title: 'Alerta'
        heightAuto: false
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.IDep_posicion_box').addClass 'input_error'
      IDep_posicion = '0'
      return false
    else
      IDep_posicion = '1'
    if $('#user_user_information_attributes_history_injuries').val() == ''
      swal
        type: 'error'
        title: 'Alerta'
        heightAuto: false
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.IDep_lesion_box').addClass 'input_error'
      IDep_lesiones = '0'
      return false
    else
      IDep_lesiones = '1'
    if IDep_sport == '1'
      if IDep_experience == '1'
        if IDep_lesiones == '1'
          if IDep_posicion == '1'
            $('#div_informacion_deportiva').addClass 'animated bounceOutLeft'
            setTimeout (->
              $("#div_informacion_deportiva").css('display','none')
              $("#div_metas_objetivos").removeAttr("style")
              return
            ), 500
    return false

eventos_metas_objetivos = ->
  $('#metas_objetivos_btn').on 'click', ->
    if $('#registro_trainer_code input').val() != "" and $("#influencer_code").val() == ""
      swal({
          title: 'Creando su rutina...',
          allowOutsideClick: false
      });
      swal.showLoading();
      return true
    else
      $('#div_metas_objetivos').addClass 'animated bounceOutLeft'
      setTimeout (->
        $("#div_metas_objetivos").css('display','none')
        $("#div_planes").removeAttr("style")
        return
      ), 500
      return false
  $('#metas_objetivos_close').on 'click', ->
    $('#metas_objetivos_modal').addClass 'animated bounceOut'
    return false

eventos_planes = ->
  validacion_usuario = false
  validacion_entrenador = false
  validacion_escuela = false
  $('#PP_entrenador, #PP_escuela, #PP_usuario').mouseover ->
    $(this).addClass 'tipo_hover'
    $(this).find('i').addClass 'tipo_unhover'
    $(this).find('h5').addClass 'tipo_unhover'
    $(this).find('p').addClass 'tipo_unhover'
    return
  $('#PP_entrenador, #PP_escuela, #PP_usuario').mouseout ->
    $(this).removeClass 'tipo_hover'
    $(this).find('i').removeClass 'tipo_unhover'
    $(this).find('h5').removeClass 'tipo_unhover'
    $(this).find('p').removeClass 'tipo_unhover'
    return

  ### ELECCION ENTRENADOR ###

  $('#PP_entrenador').on 'click', ->
    $(this).addClass 'animated pulse'
    $(this).addClass 'tipo_seleccionado'
    $(this).find('i').addClass 'deseleccion'
    $(this).find('h5').addClass 'deseleccion'
    $(this).find('p').addClass 'deseleccion'
    $('#PP_escuela, #PP_usuario').removeClass 'tipo_seleccionado animated pulse'
    $('#PP_escuela i, #PP_escuela h5, #PP_usuario i, #PP_usuario h5').removeClass 'tipo_seleccionado, deseleccion'
    $('#PP_escuela p, #PP_usuario p').removeClass 'deseleccion'
    $('#PP_btn').show 500
    validacion_entrenador = true
    validacion_escuela = false
    validacion_usuario = false
    return

  ### ELECCION ESCUELA ###

  $('#PP_escuela').on 'click', ->
    $(this).addClass 'animated pulse'
    $(this).addClass 'tipo_seleccionado'
    $(this).find('i').addClass 'deseleccion'
    $(this).find('h5').addClass 'deseleccion'
    $(this).find('p').addClass 'deseleccion'
    $('#PP_entrenador, #PP_usuario').removeClass 'tipo_seleccionado animated pulse'
    $('#PP_entrenador i, #PP_entrenador h5, #PP_usuario i, #PP_usuario h5').removeClass 'tipo_seleccionado, deseleccion'
    $('#PP_entrenador p, #PP_usuario p').removeClass 'deseleccion'
    $('#PP_btn').show 500
    validacion_escuela = true
    validacion_entrenador = false
    validacion_usuario = false
    return

  ### ELECCION USUARIO ###

  $('#PP_usuario').on 'click', ->
    $(this).addClass 'animated pulse'
    $(this).addClass 'tipo_seleccionado'
    $(this).find('i').addClass 'deseleccion'
    $(this).find('h5').addClass 'deseleccion'
    $(this).find('p').addClass 'deseleccion'
    $('#PP_entrenador, #PP_escuela').removeClass 'tipo_seleccionado animated pulse'
    $('#PP_entrenador i, #PP_entrenador h5, #PP_escuela i, #PP_escuela h5').removeClass 'tipo_seleccionado, deseleccion'
    $('#PP_entrenador p, #PP_usuario p').removeClass 'deseleccion'
    $('#PP_btn').show 500
    validacion_usuario = true
    validacion_escuela = false
    validacion_entrenador = false
    return

  $('#PP_btn').on 'click', ->
    if validacion_entrenador == true
      if $("#influencer_code").val() == ""
        $("#conekta_plan").val("trimestral")
      else
        $("#conekta_plan").val("trimestral_influencer")
      $('#PP_usuario').hide 400
      $('#PP_escuela').hide 400
    else
      if validacion_escuela == true
        if $("#influencer_code").val() == ""
          $("#conekta_plan").val("anual")
        else
          $("#conekta_plan").val("anual_influencer")
        $('#PP_usuario').hide 400
        $('#PP_entrenador').hide 400
      else
        if validacion_usuario == true
          if $("#influencer_code").val() == ""
            $("#conekta_plan").val("mensual")
          else
            $("#conekta_plan").val("mensual_influencer")
          $('#PP_entrenador').hide 400
          $('#PP_escuela').hide 400
    $('#div_planes').addClass 'animated bounceOutLeft'
    setTimeout (->
      $("#div_metas_objetivos").css('display','none')
      $("#div_forma_pago").removeAttr("style")
      return
    ), 500
    return false
  $('#metas_objetivos_close').on 'click', ->
    $('#metas_objetivos_modal').addClass 'animated bounceOut'
    return false

eventos_forma_pago = ->
  conektaSuccessResponseHandler = (token) ->
    #Inserta el token_id en la forma para que se envíe al servidor
    if $("#customer_token").length == 0
      $("#div_forma_pago").append($('<input type="hidden" name="user[customer_token]" id="customer_token">').val(token.id))
    $form = $("#new_user")
    $.ajax
      type: "POST"
      url: "/create_conekta_subscription"
      data: token: token.id, name: $('.FPago_tarjeta_tutor').val(), email: $("#user_email").val(), plan: $("#conekta_plan").val()
      dataType: "json",
      success: (data) ->
        if data.error
          swal.close();
          swal 'Error', 'Hubo un problema con la tarjeta ingresada.', 'warning', 'heightAuto: false'
        else
          $("#customer_token").val(data.response.customer_id)
          $form.get(0).submit()
    return

  conektaErrorResponseHandler = (response) ->
    swal.close();
    swal
      type: 'error'
      title: 'Alerta'
      heightAuto: false
      text: response.message_to_purchaser
      allowEscapeKey: true
      allowOutsideClick: true
      confirmButtonText: 'Regresar'
      confirmButtonClass: 'login_sweetalert'
    return

  $('.FPago_tarjeta_tutor').on 'keypress', ->
    $('.input_box_tutor').removeClass 'input_error'
    return
  $('.FPago_tarjeta_num').on 'keypress', ->
    $('.input_box_num').removeClass 'input_error'
    return
  $('.CVC_CODE').on 'keypress', ->
    $('.input_box_cvc').removeClass 'input_error'
    return

  ###  CAMBIO A PAYPAL###

  $('.FPago_metodo_Paypal').on 'click', ->
    $('#Terminar_modal').addClass 'animated lightSpeedOut '
    return

  ### CAMBIO A PAYPAL END ###

  $('#FPago_btn').on 'click', ->
    if $('.FPago_tarjeta_num').val() == ''
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        heightAuto: false
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.input_box_num').addClass 'input_error'
      return false
    if $('.FPago_tarjeta_tutor').val() == ''
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        heightAuto: false
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.input_box_tutor').addClass 'input_error'
      return false
    if $('.CVC_CODE').val() == ''
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        heightAuto: false
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.input_box_cvc').addClass 'input_error'
      return false
    swal({
        title: 'Procesando...',
        allowOutsideClick: false
    });
    swal.showLoading();
    tokenParams = 'card':
      'number': $('.FPago_tarjeta_num').val()
      'name': $('.FPago_tarjeta_tutor').val()
      'exp_year': $('#FPago_año_vencimiento option:selected').text()
      'exp_month': $('#FPago_mes_vencimiento option:selected').text()
      'cvc': $('.CVC_CODE').val()
    Conekta.Token.create tokenParams, conektaSuccessResponseHandler, conektaErrorResponseHandler
    return false
  return

eventos_entrenador = ->
  $("#ientrenador_btn").click ->
    if $("#ientrenador_contacto").val() == ""
      swal
        type: 'error'
        title: 'Alerta'
        heightAuto: false
        text: 'Por favor Ingrese su Nombre de Contacto'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'registro_sweetalert'
      return false
    if $("#ientrenador_telefono").val() == ""
      swal
        type: 'error'
        heightAuto: false
        title: 'Alerta'
        text: 'Por favor Ingrese su Telefono'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'registro_sweetalert'
      return false
    swal({
        title: 'Procesando...',
        allowOutsideClick: false
        heightAuto: false
    });
    swal.showLoading();
  return

eventos_btn_tipos_usuarios = (validacion_usuario,validacion_entrenador,validacion_escuela) ->
  if validacion_entrenador == true
    $('#TU_usuario').hide 400
    $('#TU_escuela').hide 400
    $('#TU_modal').addClass 'animated bounceOutLeft'
    $("#div_datos_personales").remove()
    $("#div_informacion_deportiva").remove()
    $("#div_metas_objetivos").remove()
    $("#user_type_id").val(2)
    setTimeout (->
      $("#div_tipo_usuario").css('display','none')
      $("#div_entrenador_modal").removeAttr("style")
      return
    ), 800
  else
    if validacion_escuela == true
      $('#TU_usuario').hide 400
      $('#TU_entrenador').hide 400
      $('#TU_modal').addClass 'animated bounceOutLeft'
      $("#div_datos_personales").remove()
      $("#div_informacion_deportiva").remove()
      $("#div_metas_objetivos").remove()
      $("#user_type_id").val(2)
      setTimeout (->
        $("#div_tipo_usuario").css('display','none')
        $("#div_entrenador_modal").removeAttr("style")
        return
      ), 800
    else
      if validacion_usuario == true
        $('#TU_entrenador').hide 400
        $('#TU_escuela').hide 400
        $('#TU_modal').addClass 'animated bounceOutLeft'
        $("#div_entrenador_modal").remove()
        $("#user_type_id").val(3)
        setTimeout (->
          $("#div_tipo_usuario").css('display','none')
          $("#div_datos_personales").removeAttr("style")
          return
        ), 800
  return false

addkg = ->
  contenido_tmp = $('#IP_peso').val() + ' kg'
  $('#IP_peso').val ''
  $('#IP_peso').val contenido_tmp
  kg_var++
  return