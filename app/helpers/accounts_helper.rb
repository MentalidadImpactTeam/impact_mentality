module AccountsHelper
  def account_subscription_description(estatus)
    case estatus
    when 1
      "ACTIVA"
    when 0
      "SUSPENDIDA"
    end
  end

  def account_subscription_plan(user)
    if user.plan.present?
      if user.plan == "mensual" or user.plan == "mensual_influencer"
        "PLAN MENSUAL"
      elsif user.plan == "trimestral" or user.plan == "trimestral_influencer"
        "PLAN TRIMESTRAL"
      elsif user.plan == "anual" or user.plan == "anual_influencer"
        "PLAN ANUAL"
      else
        ""
      end
    else
      ""
    end
  end

  def account_subscription_payment(user)
    if user.plan.present?
      if user.plan == "mensual"
        "$150 M.N."
      elsif user.plan == "trimestral"
        "$360 M.N."
      elsif user.plan == "anual"
        "$1460 M.N."
      elsif user.plan == "mensual_influencer"
        "$127.50 M.N."
      elsif user.plan == "trimestral_influencer"
        "$306 M.N."
      elsif user.plan == "anual_influencer"
        "$1241 M.N."
      else
        ""
      end
    else
      ""
    end
  end

  def account_subscription_billing_date(suscripcion)
    if suscripcion.present?
      billing_date = suscripcion.end_date
      billing_day = billing_date.day.to_s.rjust(2,"0")
      billing_year = billing_date.year
  
      month = ""
      case billing_date.month
      when 1
        month = "ENE"
      when 2
        month = "FEB"
      when 3
        month = "MAR"
      when 4
        month = "ABR"
      when 5
        month = "MAY"
      when 6
        month = "JUN"
      when 7
        month = "JUL"
      when 8
        month = "AGO"
      when 9
        month = "SEPT"
      when 10
        month = "OCT"
      when 11
        month = "NOV"
      when 12
        month = "DIC"
      end
  
      billing_day.to_s + "/" + month + "/" + billing_year.to_s
    else
      ""
    end
  end
end
