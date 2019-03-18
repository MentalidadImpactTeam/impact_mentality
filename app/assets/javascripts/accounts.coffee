Conekta.setPublicKey("key_WNFhLVfrxEbDMH8qTkdXo3Q");

AccountController = Paloma.controller('Accounts')
AccountController::index = ->
  metodos_menu("CUENTA")
  account_open_card_modal()
  account_add_card()
  account_update()
  account_cancelar_suscripcion()

  numtarjeta = new Cleave('#cuenta_num',
    creditCard: true
    onCreditCardTypeChanged: (type) ->
      # update UI ...
      return
  )
  csv = new Cleave('#cuenta_csv',
    numeral: true
    numeralIntegerScale: 3)
  fecha = new Cleave('#cuenta_fechatxt',
    date: true
    datePattern: [
      'm'
      'y'
    ])


account_open_card_modal = ->
  agregartar = $('#sistema_cuenta_agregartarjeta')
  $('.sistema_cuenta_agregar').on 'click', (event) ->
    agregartar.css 'display', 'flex'
    # swal(
    #   title: 'AGREGAR MÉTODO DE PAGO'
    #   text: 'Elige entre tarjeta de crédito o una cuenta de Paypal'
    #   type: 'question'
    #   showCancelButton: true
    #   showConfirmButton: true
    #   confirmButtonColor: '#3085d6'
    #   cancelButtonColor: '#d33'
    #   cancelButtonText: 'Cuenta de Paypal'
    #   confirmButtonText: 'Tarjeta de crédito'
    #   showCloseButton: true).then (result) ->
    #   if result.value
    #     agregartar.css 'display', 'flex'
    #   else if result.dismiss == swal.DismissReason.cancel
    #     $('<div class="sistema_cuenta_tarjeta d-flex flex-column justify-content-between" id="sistema_cuenta_paypal"> <div class="sistema_cuenta_borrar"></div><div class="sistema_cuenta_circulo"></div></div>').insertBefore '.sistema_cuenta_agregar'
    #     $('.sistema_cuenta_circulo').click ->
    #       account_card_default(this)
          
    #     $('.sistema_cuenta_borrar').click ->
    #       account_card_delete($(this))
    #       return
    #     if $('.sistema_cuenta_tarjeta').length < 2
    #       $('.sistema_cuenta_agregar').css 'display', 'flex'
    #     else
    #       $('.sistema_cuenta_agregar').css 'display', 'none'
    #   return
    return
  
  if $('.sistema_cuenta_tarjeta').length >= 2
    $('.sistema_cuenta_agregar').css 'display', 'none'
  $('body').keydown (event) ->
    if event.which == 27
      agregartar.css 'display', 'none'
      $('#cuenta_csv').val ''
      $('#cuenta_num').val ''
      $('#cuenta_nombre').val ''
      $('#cuenta_fechatxt').val ''
    return
  
  $('.sistema_cuenta_cerrar').on 'click', (event) ->
    agregartar.css 'display', 'none'
    $('#cuenta_csv').val ''
    $('#cuenta_num').val ''
    $('#cuenta_nombre').val ''
    $('#cuenta_fechatxt').val ''
    return
  $('.sistema_cuenta_borrar').click ->
    account_card_delete($(this))
    return
  
  $('.sistema_cuenta_circulo').click ->
    account_card_default(this)
    return

account_add_card = ->
  agregartar = $('#sistema_cuenta_agregartarjeta')
  $('.sistema_p_botoncredito').click ->
    csvv = $('#cuenta_csv').val()
    numv = $('#cuenta_num').val()
    nombrev = $('#cuenta_nombre').val()
    fechav = $('#cuenta_fechatxt').val()
    numcont = numv.length
    numcont = numcont - 6
    cont = 0
    while cont <= numcont
      numv = numv.substr(0, cont) + numv.substr(cont).replace(/[\S]/, '*')
      cont++

    ### EXITO ###

    if csvv != '' and numv != '' and nombrev != '' and fechav != ''
      agregartar.css 'display', 'none'
      num = $('#cuenta_num').val()
      fecha = $('#cuenta_fechatxt').val()
      
      conektaSuccessResponseHandler = (token) ->
        $.ajax
            type: "post"
            url: "/accounts/add_card"
            data: customer_token: token.id
            dataType: "json",
            success: (data) ->
              swal.close();
              $('<div class="sistema_cuenta_tarjeta d-flex flex-column"><input type="hidden" class="hidden_card" value="'+data["id"]+'"><div class="sistema_cuenta_borrar"></div> <div class="sistema_cuenta_marca"></div> <div class="sistema_cuenta_numt">' + numv + '</div> <div class="d-flex flex-row"> <div class="sistema_cuenta_fechatxt d-flex flex-column"> <div> FECHA </div> <div> CAD. </div> </div> <div class="sistema_cuenta_num">' + fecha + '</div> </div> <div class="sistema_cuenta_circulo"></div> </div>').insertBefore '.sistema_cuenta_agregar'
              $('.sistema_cuenta_circulo').click ->
                account_card_default(this)
              $('.sistema_cuenta_borrar').click ->
                account_card_delete($(this))
              if $('.sistema_cuenta_tarjeta').length < 2
                $('.sistema_cuenta_agregar').css 'display', 'flex'
              else
                $('.sistema_cuenta_agregar').css 'display', 'none'

              ### RESET VALUES ###

              $('#cuenta_csv').val ''
              $('#cuenta_num').val ''
              $('#cuenta_nombre').val ''
              $('#cuenta_fechatxt').val ''
        return

      conektaErrorResponseHandler = (response) ->
        swal.close();
        swal
          type: 'error'
          title: 'No se puede agregar su tarjeta'
          text: response.message_to_purchaser
          confirmButtonText: 'Entendido'
          heightAuto: false
        return
      
      
      tokenParams = 'card':
        'number':num
        'name': nombrev
        'exp_year': fechav.split("/")[1]
        'exp_month': fechav.split("/")[0]
        'cvc': csvv
      swal.showLoading();
      Conekta.Token.create tokenParams, conektaSuccessResponseHandler, conektaErrorResponseHandler
    else
      swal
        type: 'error'
        title: 'No se puede agregar su tarjeta'
        text: 'Hay un campo vacío'
        confirmButtonText: 'Entendido'
        heightAuto: false
    return

account_cancelar_suscripcion = ->
  $('#sistema_cuenta_cancelar_txt').click ->
    if $(".sistema_cuenta_estadoa").text() == "ACTIVA"
      swal(
        title: '¿Estas seguro de cancelar tu suscripción?'
        footer: 'Al cancelar tu suscripción, perderdas acceso a tus rutinas anteriores al terminar el mes'
        type: 'warning'
        showCancelButton: true
        confirmButtonColor: '#3085d6'
        cancelButtonColor: '#d33'
        cancelButtonText: 'No, quiero seguir suscrito'
        confirmButtonText: 'Sí, quiero cancelar mi suscripción'
        heightAuto: false
        showCloseButton: true).then (result) ->
          if result.value
            swal
              text: 'Procesando...'
              allowOutsideClick: false
              allowEscapeKey: false
              allowEnterKey: false
              heightAuto: false
              onOpen: ->
                swal.showLoading()
            $.ajax
              type: "POST"
              url: "/accounts/cancel_subscription"
              dataType: "text",
              success: (data) ->
                $(".sistema_cuenta_estadoa").text("SUSPENDIDA")
                $("#sistema_cuenta_cancelar_txt").text("Reanudar subscripción")
                swal.close();
                swal
                  type: 'success'
                  title: 'Exito'
                  text: 'Suscripcion Cancelada'
                  confirmButtonText: 'Entendido'
                  heightAuto: false
    else
      if $(".sistema_cuenta_tarjeta").length == 0
        swal('Error','No tiene ninguna tarjeta agregada.','heightAuto: false','warning')
      else
        swal(
          title: '¿Estas seguro de reanudar tu suscripción?'
          footer: 'Al reanudar tu suscripción, se volvera a cobrar el costo mensual'
          type: 'warning'
          showCancelButton: true
          confirmButtonColor: '#3085d6'
          cancelButtonColor: '#d33'
          cancelButtonText: 'No, quiero seguir suspendido'
          confirmButtonText: 'Sí, quiero reanudar mi suscripción'
          heightAuto: false
          showCloseButton: true).then (result) ->
            if result.value
              swal
                text: 'Procesando...'
                allowOutsideClick: false
                allowEscapeKey: false
                allowEnterKey: false
                heightAuto: false
                onOpen: ->
                  swal.showLoading()
              $.ajax
                type: "POST"
                url: "/accounts/add_subscription"
                dataType: "text",
                success: (data) ->
                    swal.close();
                    if data == "OK"
                      $(".sistema_cuenta_estadoa").text("ACTIVA")
                      $("#sistema_cuenta_cancelar_txt").text("Cancelar subscripción")
                      swal
                        type: 'success'
                        title: 'Exito'
                        text: 'Suscripcion Reanudada'
                        confirmButtonText: 'Entendido'
                        heightAuto: false
                    else
                      swal('Error','Hubo un error al tratar de reanudar su suscripcion, favor de revisar su tarjeta.','heightAuto: false','warning')
    return

account_update = ->
  ### CORREO ###
  $('#sistema_cuenta_datos_editar_correo').click ->
  
    swal(
      input: 'text'
      title: 'Cambiar correo electrónico'
      text: 'Escribe tu nuevo correo electrónico'
      heightAuto: false
      inputAttributes: autocapitalize: 'off'
      showCancelButton: true
      confirmButtonText: 'Guardar'
      showCloseButton: true
      heightAuto: false
      ).then (result) ->
        if result.value
          $.ajax
            type: "PUT"
            url: "/users"
            data: user: { email: result.value }
            dataType: "text",
            success: (data) ->
              swal
                type: 'success'
                title: 'Se le ha enviado un correo de confirmación'
                text: 'Revise su correo electrónico para encontrar el correo de confirmación para autorizar el cambio de correo electrónico'
                confirmButtonText: 'Entendido'
                heightAuto: false
        else
          swal
            type: 'error'
            title: 'No se introdujo nuevo correo electrónico'
            confirmButtonText: 'Entendido'
            heightAuto: false
    return

  ### TELEFONO ###

  $('#sistema_cuenta_datos_editar_num').click ->
    swal(
      input: 'text'
      title: 'Cambiar número telefónico'
      text: 'Escribe tu nuevo número telefónico'
      inputAttributes: autocapitalize: 'off'
      showCancelButton: true
      confirmButtonText: 'Guardar'
      heightAuto: false
      showCloseButton: true).then (result) ->
        numnuevo = result.value
        if result.value
          user = $(".hidden_user").val()
          $.ajax
            type: "PATCH"
            url: "/profiles/" + user
            data: phone: numnuevo
            dataType: "json",
            success: (data) ->
              return
          swal
            type: 'success'
            title: 'Su número telefónico ha sido cambiado'
            confirmButtonText: 'Entendido'
            heightAuto: false
          $('#cuenta_nums').html numnuevo
        else
          swal
            type: 'error'
            title: 'No se introdujo número telefónico'
            heightAuto: false
            confirmButtonText: 'Entendido'
        return
    return

  ### PASSWORD ###

  $('#sistema_cuenta_datos_editar_pass').click ->
    swal(
      html: '<div> Escribe tu contraseña actual </div>' + '<input type="password" id="passactual" name=[user][current_password] class="swal2-input">' + '<div> Escribe tu nueva contraseña </div>' + '<input type="password" id="passnuevo" name=[user][password] class="swal2-input">' + '<div> Repetir nueva contraseña </div>' + '<input type="password" id="passnuevo2" name=[user][password_confirmation] class="swal2-input">'
      title: 'Cambiar contraseña'
      inputAttributes: autocapitalize: 'off'
      showCancelButton: true
      confirmButtonText: 'Guardar'
      heightAuto: false
      showCloseButton: true).then (result) ->
        passactual = document.getElementById('passactual').value
        passnuevo = document.getElementById('passnuevo').value
        passnuevo2 = document.getElementById('passnuevo2').value
        if passactual == '' or passnuevo == '' or passnuevo2 == ''
          swal
            type: 'error'
            heightAuto: false
            title: 'Su contraseña no pudo ser cambiada'
            text: 'Dejó un campo vacío'
            confirmButtonText: 'Entendido'
        else if passnuevo == passactual
          swal
            type: 'error'
            heightAuto: false
            title: 'Su contraseña no pudo ser cambiada'
            text: 'La contraseña actual es igual a la contraseña nueva, intente con otra contraseña'
            confirmButtonText: 'Entendido'
        else
          $.ajax
            type: "PATCH"
            url: "/users/password"
            data: user: { current_password: passactual, password: passnuevo, password_confirmation: passnuevo2 }
            dataType: "text",
            success: (data) ->
              if data == "true"
                swal
                  type: 'success'
                  heightAuto: false
                  title: 'Su contraseña ha sido cambiada'
                  confirmButtonText: 'Entendido'
                $('#cuenta_pass').html '**********'
              else if data == "incorrect_password"
                swal
                  type: 'error'
                  title: 'Su contraseña no pudo ser cambiada'
                  heightAuto: false
                  text: 'Su contraseña actual no coincide'
                  confirmButtonText: 'Entendido'
              else
                swal
                  type: 'error'
                  heightAuto: false
                  title: 'Su contraseña no pudo ser cambiada'
                  text: 'Las contraseñas nuevas no coinciden'
                  confirmButtonText: 'Entendido'
              return
        return
    return

account_card_default = (obj) ->
  $this = $(obj)
  $.ajax
    type: "POST"
    url: "/accounts/card_default"
    data: id: $this.closest(".sistema_cuenta_tarjeta").find(".hidden_card").val()
    dataType: "text",
    success: (data) ->
      $('.sistema_cuenta_circuloactive').removeClass 'sistema_cuenta_circuloactive'
      $('.sistema_cuenta_active').removeClass 'sistema_cuenta_active'
      $this.parent().addClass 'sistema_cuenta_active'
      $this.addClass 'sistema_cuenta_circuloactive'

account_card_delete = (obj) ->
  swal(
    title: 'ELIMINAR MÉTODO DE PAGO'
    text: '¿Estas seguro de eliminar el metodo de pago?'
    type: 'warning'
    showCancelButton: true
    showConfirmButton: true
    confirmButtonColor: '#3085d6'
    cancelButtonColor: '#d33'
    cancelButtonText: 'Cancelar'
    heightAuto: false
    confirmButtonText: 'Aceptar'
    showCloseButton: true).then (result) ->
      if result.value
        if $('.sistema_cuenta_tarjeta')[1]
          $.ajax
            type: "post"
            url: "/accounts/delete_card"
            data: id: obj.closest(".sistema_cuenta_tarjeta").find(".hidden_card").val()
            dataType: "text",
            success: (data) ->
              obj.parent().remove()
              if obj.parent().hasClass('sistema_cuenta_active')
                $('.sistema_cuenta_tarjeta:first').addClass 'sistema_cuenta_active'
                $('.sistema_cuenta_circulo:first').addClass 'sistema_cuenta_circuloactive'
              if $('.sistema_cuenta_tarjeta').length < 2
                $('.sistema_cuenta_agregar').css 'display', 'flex'
              else
                $('sistema_cuenta_agregar').css 'display', 'none'