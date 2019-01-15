class PlanesController < ApplicationController

    def index
    end

    def change_user_plan
        customer = Conekta::Customer.find(current_user.customer_token)
        subscription = customer.subscription.update({
            :plan => params[:plan]
        })
        render plain: "OK"
    end
end
