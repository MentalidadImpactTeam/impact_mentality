AccountController = Paloma.controller('Accounts')
AccountController::index = ->
  $('#perfil_mod_edad').hide()
  $('#perfil_mod_estatura').hide()
  $('#perfil_mod_peso').hide()
  $('#sistema_p_confirmar').hide()
  $('#perfil_edad').html '22'
  $('#perfil_altura').html '1.60'
  $('#perfil_peso').html '66'
  ed = document.getElementById('perfil_edad').value
  es = document.getElementById('perfil_altura').value
  pe = document.getElementById('perfil_peso').value
  $('.sistema_p_editar ').on 'click', (e) ->
    e.preventDefault()
    $('.sistema_p_editar').hide()
    $('#perfil_edad').hide()
    $('#perfil_altura').hide()
    $('#perfil_peso').hide()
    $('#perfil_mod_edad').attr 'placeholder', ed
    $('#perfil_mod_edad').show()
    $('#perfil_mod_estatura').attr 'placeholder', es
    $('#perfil_mod_estatura').show()
    $('#perfil_mod_peso').attr 'placeholder', pe
    $('#perfil_mod_peso').show()
    $('#sistema_p_confirmar').show()
    return
  $('#sistema_p_confirmar').on 'click', (e) ->
    e.preventDefault()
    ednueva = document.getElementById('perfil_mod_edad').value
    esnueva = document.getElementById('perfil_mod_estatura').value
    penueva = document.getElementById('perfil_mod_peso').value
    $('#perfil_mod_edad').hide()
    $('#perfil_mod_estatura').hide()
    $('#perfil_mod_peso').hide()
    $('#sistema_p_confirmar').hide()
    ed = ednueva
    es = esnueva
    pe = penueva
    $('.sistema_p_editar').show()
    $('#perfil_edad').show()
    $('#perfil_altura').show()
    $('#perfil_peso').show()
    $('#perfil_edad').html ednueva
    $('#perfil_altura').html esnueva
    $('#perfil_peso').html penueva
    return