class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render status: 200
  end

  def procesar
    data = JSON.parse(request.body.read)

    object = data['data']['object']
    if data['type'] == 'subscription.paid'
      ct = ConektaTransaction.new
      ct.json = data
      ct.save
      user = User.find_by(customer_token: object['customer_id'])
      if user.present?
        last_pay = UserConektaSubscription.find_by(user_id: user.id, estatus: 1)
        if last_pay.present?
          last_pay.estatus = 0
          last_pay.save
        end
        new_pay = UserConektaSubscription.new
        new_pay.user_id = user.id
        new_pay.estatus = 1
        new_pay.start_date = Time.at(object['billing_cycle_start']).to_date
        new_pay.end_date = Time.at(object['billing_cycle_end']).to_date
        new_pay.conekta_subscription_token = object["id"]
        new_pay.save

        user.active = 1
        user.user_information.plan = object["plan_id"]
        user.save
      end
    end

    if data['type'] == 'subscription.payment_failed'
      ct = ConektaTransaction.new
      ct.json = data
      ct.save
      user = User.find_by(customer_token: object['customer_id'])
      if user.present?
        subscription = UserConektaSubscription.find_by(user_id: user.id, estatus: 1)
        if subscription.present?
          subscription.estatus = 0
          subscription.payment_attemps += 1
          subscription.save

          user.active = 0
          user.save
        end
      end
    end

    if data['type'] == 'subscription.canceled'
      ct = ConektaTransaction.new
      ct.json = data
      ct.save
      user = User.find_by(customer_token: object['customer_id'])
      subscription = UserConektaSubscription.find_by(user_id: user.id, estatus: 1)
        if subscription.present?
          subscription.estatus = 0
          subscription.save

          user.active = 0
          user.save
        end
    end

    render status: 200, layout: false
  end

  def paypal_payment
    data = JSON.parse(request.body.read)

    render status: 200
  end
end
