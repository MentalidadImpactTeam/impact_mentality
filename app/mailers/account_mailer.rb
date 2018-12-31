class AccountMailer < ApplicationMailer
  default from: "administracion@mentalidadimpact.com"

  def frase1(email)
    mail(to: email, subject: 'Test Email')
  end
end
