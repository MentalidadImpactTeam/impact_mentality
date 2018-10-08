kg_var = 0
Conekta.setPublicKey("key_HcFQfz7edHvGnSxP8cettSA");

RegistrationController = Paloma.controller('Users/Registrations')
RegistrationController::new = ->
  eventos_registro()
  eventos_datos_personales()
  eventos_datos_deportivos()
  eventos_metas_objetivos()
  eventos_forma_pago()

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
    if $('#user_email').val() == ''
      registro_correoval = 1
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese su Correo Electrónico'
        allowEscapeKey: true
        allowOutsideClick: true
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
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'registro_sweetalert'
      $('#user_email').addClass 'input_error'
      return false
    if $('#user_password').val() == ''
      registro_contval = 1
      swal
        type: 'error'
        title: 'Alerta'
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
                  $("#div_datos_personales").removeAttr("style")
                  return
                ), 800
      return false
    return
  
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
          allowEscapeKey: true
          allowOutsideClick: true
          confirmButtonText: 'Regresar'
          confirmButtonClass: 'login_sweetalert'
        $('#input_box_apellido').addClass 'input_error'
        return false
      else
        $('#input_box_apellido').removeClass 'input_error'
        if $('#IP_Experiencia').val() == 'vacio'
          swal
            type: 'error'
            title: 'Alerta'
            text: 'Por favor Ingrese su Experiencia'
            allowEscapeKey: true
            allowOutsideClick: true
            confirmButtonText: 'Regresar'
            confirmButtonClass: 'login_sweetalert'
          $('#input_box_exp').addClass 'input_error'
          return false
        else
          $('#input_box_exp').removeClass 'input_error'
          if $('#IP_genero').val() == 'vacio'
            swal
              type: 'error'
              title: 'Alerta'
              text: 'Por favor Ingrese su Genero'
              allowEscapeKey: true
              allowOutsideClick: true
              confirmButtonText: 'Regresar'
              confirmButtonClass: 'login_sweetalert'
            $('#input_box_gen').addClass 'input_error'
            return false
          else
            $('#input_box_gen').removeClass 'input_error'
            if $('#IP_peso').val() == ''
              swal
                type: 'error'
                title: 'Alerta'
                text: 'Por favor Ingrese su Peso'
                allowEscapeKey: true
                allowOutsideClick: true
                confirmButtonText: 'Regresar'
                confirmButtonClass: 'login_sweetalert'
              $('#input_box_peso').addClass 'input_error'
              return false
            else
              $('#input_box_peso').removeClass 'input_error'
              if $('#IP_Estatura').val() == 'vacio'
                swal
                  type: 'error'
                  title: 'Alerta'
                  text: 'Por favor Ingrese su Estatura'
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
    if $('#ID_deporte').val() == 'vacio'
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese su Deporte'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('#input_box_deporte').addClass 'input_error'
      return false
    else
      if $('#ID_pos_obj').val() == 'vacio'
        swal
          type: 'error'
          title: 'Alerta'
          text: 'Por favor Ingrese su Posicion'
          allowEscapeKey: true
          allowOutsideClick: true
          confirmButtonText: 'Regresar'
          confirmButtonClass: 'login_sweetalert'
        $('#input_box_p').addClass 'input_error'
        return false
      else
        if $('#lesiones_input').val() == 'vacio'
          swal
            type: 'error'
            title: 'Alerta'
            text: 'Por favor Ingrese su Lesion'
            allowEscapeKey: true
            allowOutsideClick: true
            confirmButtonText: 'Regresar'
            confirmButtonClass: 'login_sweetalert'
          $('#input_box_les').addClass 'input_error'
          return false
        else
          if $('#ID_exp').val() == 'vacio'
            swal
              type: 'error'
              title: 'Alerta'
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
  Basket = '<option value="poste">Poste</option><option value="botador">Batoador-Ala</option>'
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
    
    if $('#user_user_information_attributes_sport').val() == 'vacio'
      swal
        type: 'error'
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
    if $('#user_user_information_attributes_experience').val() == 'vacio'
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.IDep_exp_box').addClass 'input_error'
      IDep_experience = '0'
      return false
    else
      IDep_experience = '1'
    if $('#user_user_information_attributes_position').val() == 'vacio'
      swal
        type: 'error'
        title: 'Alerta'
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
    if $('#user_user_information_attributes_history_injuries').val() == 'vacio'
      swal
        type: 'error'
        title: 'Alerta'
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
    $('#div_metas_objetivos').addClass 'animated bounceOutLeft'
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
    div_forma_pago = $("#div_forma_pago").append($('<input type="hidden" name="user[customer_token]" id="customer_token">').val(token.id))
    $form = $("#new_user")
    $form.get(0).submit()
    return

  conektaErrorResponseHandler = (response) ->
    # $form.find(".card-errors").text(response.message_to_purchaser);
    # $form.find("button").prop("disabled", false);
    console.log response.message_to_purchaser
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
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.input_box_cvc').addClass 'input_error'
      return false
    tokenParams = 'card':
      'number': $('.FPago_tarjeta_num').val()
      'name': $('.FPago_tarjeta_tutor').val()
      'exp_year': $('#FPago_año_vencimiento option:selected').text()
      'exp_month': $('#FPago_mes_vencimiento option:selected').text()
      'cvc': $('.CVC_CODE').val()
    Conekta.Token.create tokenParams, conektaSuccessResponseHandler, conektaErrorResponseHandler
    return false
  return 


addkg = ->
  contenido_tmp = $('#IP_peso').val() + ' kg'
  $('#IP_peso').val ''
  $('#IP_peso').val contenido_tmp
  kg_var++
  return