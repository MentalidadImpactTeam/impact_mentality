RegistrationController = Paloma.controller('Users/Registrations')
RegistrationController::new = ->
  $('.DP_nombre_box').on 'click', ->
    $('.DP_nombre_box').removeClass 'input_error'
    return
  $('.DP_apellido_box').on 'click', ->
    $('.DP_apellido_box').removeClass 'input_error'
    return
  $('.DP_genero_box').on 'click', ->
    $('.DP_genero_box').removeClass 'input_error'
    return
  $('.DP_estatura_box').on 'click', ->
    $('.DP_estatura_box').removeClass 'input_error'
    return
  $('.DP_peso_box').on 'click', ->
    $('.DP_peso_box').removeClass 'input_error'
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
  
  #CLICK EVENT 
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
  
  $('#DP_btn').on 'click', (e) ->
    DP_nombre = '0'
    DP_apellido = '0'
    DP_genero = '0'
    DP_estatura = '0'
    DP_peso = '0'

    if $('#user_user_information_attributes_first_name').val() == ''
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.DP_nombre_box').addClass 'input_error'
      DP_nombre = '0'
      return false
    else
      DP_nombre = '1'
    if $('#user_user_information_attributes_last_name').val() == ''
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.DP_apellido_box').addClass 'input_error'
      DP_apellido = '0'
      return false
    else
      DP_apellido = '1'
    if $('#user_user_information_attributes_genre').val() == 'vacio'
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.DP_genero_box').addClass 'input_error'
      DP_genero = '0'
      return false
    else
      DP_genero = '1'
    if $('#user_user_information_attributes_height').val() == 'vacio'
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.DP_estatura_box').addClass 'input_error'
      DP_estatura = '0'
      return false
    else
      DP_estatura = '1'
    if $('#user_user_information_attributes_weight').val() == 'vacio'
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese los espacios en rojo'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('.DP_peso_box').addClass 'input_error'
      DP_peso = '0'
      return false
    else
      DP_peso = '1'
    if DP_nombre == '1'
      if DP_apellido == '1'
        if DP_estatura == '1'
          if DP_peso == '1'
            if DP_genero == '1'
              $('#div_datos_personales').addClass 'animated bounceOutLeft'
              setTimeout (->
                $("#div_datos_personales").css('display','none')
                $("#div_informacion_deportiva").removeAttr("style")
                return
              ), 500
    return false

  # $('#new_user').on 'submit', (e) ->
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
    if user_user_information_attributes_position == '1'
      if IDep_experience == '1'
        if IDep_lesiones == '1'
          if IDep_posicion == '1'
            $('#div_informacion_deportiva').addClass 'animated bounceOutLeft'
            return true
    return


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