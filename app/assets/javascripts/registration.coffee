RegistrationController = Paloma.controller('Users/Registrations')
RegistrationController::new = ->
  #CLICK EVENT 
  $('#user_email, #user_password, #user_password_confirmation').on 'keyup', ->
    $(this).removeClass 'input_error'
    return
  $('#new_user').on 'submit', (e) ->
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
      if $('#user_email').val() != ''
        if $('#user_email').val() != ''
          $('#registro_modal').addClass 'animated bounceOutUp'
          return true
    return
  #END OF CLICK EVENT REGISTRO BTN
  $('#registro_close').on 'click', ->
    $('#registro_modal').addClass 'animated bounceOut'
    return