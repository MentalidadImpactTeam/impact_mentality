
LoginController = Paloma.controller('Users/Sessions')
LoginController::new = ->
  if $(".alert").text() == "You have to confirm your email address before continuing."
    swal
      type: 'error'
      title: 'Alerta'
      text: 'Favor de confirmar su cuenta.'
      allowEscapeKey: true
      allowOutsideClick: true
      confirmButtonText: 'Regresar'
      confirmButtonClass: 'login_sweetalert'
  else if $(".alert").text() != "Your email address has been successfully confirmed." and $(".alert").text() != ""
    swal
      type: 'error'
      title: 'Alerta'
      text: 'Usuario o password Incorrectos'
      allowEscapeKey: true
      allowOutsideClick: true
      confirmButtonText: 'Regresar'
      confirmButtonClass: 'login_sweetalert'
    #CLICK EVENT
  $('#user_email, #user_password').on 'keyup', ->
    $(this).removeClass 'input_error'
    return
  $('#new_user').on 'submit', ->
    if $('#user_password').val() == ''
      login_contval = 1
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese su Contraseña'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('#user_password').addClass 'input_error'
      return false
    if $('#user_email').val() == ''
      login_correoval = 1
      swal
        type: 'error'
        title: 'Alerta'
        text: 'Por favor Ingrese su Correo Electrónico'
        allowEscapeKey: true
        allowOutsideClick: true
        confirmButtonText: 'Regresar'
        confirmButtonClass: 'login_sweetalert'
      $('#user_email').addClass 'input_error'
      return false
    if $('#user_email').val() != '' and $('#user_password').val() != ''
      $('#login_modal').addClass 'animated bounceOutUp'
    #END OF CLICK EVENT login BTN
    return
  $('#login_close').on 'click', ->
    $('#login_modal').addClass 'animated bounceOut'
    return