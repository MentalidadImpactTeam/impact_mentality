class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render plain: "OK"
  end

  def procesar
    data = JSON.parse(request.body.read)
    object = data['data']['object']
    # byebug
    if data['type'] == 'subscription.paid'
      # payment_method = object['payment_method']['type']
      # msg = "Tu pago con #{payment_method} ha sido comprobado"
      # puts msg

      user = User.find_by(customer_token: object['customer_id'])
      if user.present?
        last_pay = UserConektaSubscription.find_by(user_id: user.id)
        if last_pay.present?
          last_pay.esatus = 0
          last_pay.save
        end
        new_pay = UserConektaSubscription.new
        new_pay.user_id = user.id
        new_pay.estatus = 1
        new_pay.start_date = Time.at(object['billing_cycle_start']).to_date
        new_pay.end_date = Time.at(object['billing_cycle_end']).to_date
        new_pay.save
      end
      # ExampleMailer.email(data, msg)
    end

    render status: 200
  end

  def paypal_payment
    data = JSON.parse(request.body.read)

    render status: 200
  end
end
