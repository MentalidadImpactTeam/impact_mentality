class AccountsController < ApplicationController
  def index
    @cards = UserConektaToken.where(user_id: current_user.id)
    @subscription = UserConektaSubscription.where(user_id: current_user.id).last
    if @subscription.present?
      @estatus = @subscription.estatus
    else
      @estatus = 1
    end
  end

  def add_card
    customer = Conekta::Customer.find(current_user.customer_token)
    payment_source   = customer.create_payment_source(type: "card", token_id: params["customer_token"])
    
    user_conekta = UserConektaToken.new
    user_conekta.user_id = current_user.id
    user_conekta.token =  payment_source["id"]
    user_conekta.default = 0
    user_conekta.last_digits = payment_source["last4"]
    user_conekta.exp_month = payment_source["exp_month"]
    user_conekta.exp_year = payment_source["exp_year"]
    user_conekta.brand = payment_source["brand"].downcase
    user_conekta.save


    render json: { :id => user_conekta.id }
  end

  def delete_card
    user_conekta = UserConektaToken.find(params[:id])
    customer = Conekta::Customer.find(current_user.customer_token)
    customer.payment_sources.keys.each do |key|
      if customer.payment_sources[key]["id"] == user_conekta.token
        customer.payment_sources[key].delete
        user_conekta.delete
        UserConektaToken.where(user_id: current_user.id).update_all(default: 1)

        user_conekta = UserConektaToken.find_by(user_id: current_user.id)
        customer.subscription.update(:card_id => user_conekta.token)
        break
      end
    end

    render plain: "OK"
  end

  def card_default
    UserConektaToken.where(user_id: current_user.id).update_all(default: 0)
    
    user_conekta = UserConektaToken.find(params[:id])
    user_conekta.default = 1
    user_conekta.save

    customer = Conekta::Customer.find(current_user.customer_token)
    customer.subscription.update({
      :card => user_conekta.token
    })

    render plain: "OK"
  end
end
