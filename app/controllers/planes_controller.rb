class PlanesController < ApplicationController

    def index
        @has_cards = UserConektaToken.where(user_id: current_user.id).present?
    end

    def change_user_plan
        customer = Conekta::Customer.find(current_user.customer_token)
        
        if customer.subscription.nil?
            subscription = customer.create_subscription({
                :plan => params[:plan]
            })
        else
            subscription = customer.subscription.update({
                :plan => params[:plan]
            })
        end

        current_user.active = 1
        current_user.save

        current_user.user_information.plan = params[:plan]
        current_user.user_information.save

        render plain: "OK"
    end

end
