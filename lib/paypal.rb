module Paypal
  def self.get_access_token
    url = URI.parse(ENV["paypal_host"])
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new("/v1/oauth2/token")
    request.basic_auth(ENV['paypal_client'], ENV['paypal_secret'])
    request["Accept"] = "application/json"
    request["Accept-Language"] = "en_US"
    request.set_form_data(
      "grant_type" => "client_credentials",
    )
    response = http.request(request)
    
    begin
      response = JSON.parse(response.body)
    rescue => exception
      response = JSON.parse(eval(response.body))
    end
    response['app_id']
    return response['access_token']
  end

  def self.create_plan(token)
    url = URI.parse(ENV["paypal_host"])
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new("/v1/payments/billing-plans/")

    request.content_type = "application/json"
    request["Authorization"] = "Bearer " + token
    request.body = JSON.dump({
      "name" => "Plan prueba paypal",
      "description" => "Plan de pruebas paypal mentalidad impact",
      "type" => "INFINITE",
      "payment_definitions" => [
        {
          "name" => "Pago mensual",
          "type" => "REGULAR",
          "frequency" => "MONTH",
          "frequency_interval" => "1",
          "amount" => {
            "value" => "100",
            "currency" => "MXN"
          }
        }
      ],
      "merchant_preferences" => {
        "return_url" => "http://localhost:3000/active_confirmation",
        "cancel_url" => "https://example.com/cancel",
        "auto_bill_amount" => "YES",
        "initial_fail_amount_action" => "CONTINUE",
        "max_fail_attempts" => "3"
      }
    })

    response = http.request(request)
    
    begin
      response = JSON.parse(response.body)
    rescue => exception
      response = JSON.parse(eval(response.body))
    end
    return response['id']
  end

  def self.activate_plan(plan_id, token)
    url = URI.parse(ENV["paypal_host"])
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Patch.new("/v1/payments/billing-plans/" + plan_id)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer " + token
    request.body = JSON.dump([
      {
        "op" => "replace",
        "path" => "/",
        "value" => {
          "state" => "ACTIVE"
        }
      }
    ])
    response = http.request(request)
    
    return response.code == "200" ? "OK" : "BAD"
  end

  def self.create_agreement(plan_id, token)
    url = URI.parse(ENV["paypal_host"])
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    
    start_date = Time.now
    start_date = start_date + 2.hours

    request = Net::HTTP::Post.new("/v1/payments/billing-agreements/")
    request.content_type = "application/json"
    request["Authorization"] = "Bearer " + token
    # request.body = JSON.dump({
    #   "name" => "Mentalidad Impact Suscripcion Mensual",
    #   "description" => "Suscripcion Mensual a la aplicacion de Mentalidad Impact.",
    #   "start_date" => start_date.strftime("%FT%T%:z"),
    #   "plan" => {
    #     "id" => plan_id
    #   },
    #   "payer" => {
    #     "payment_method" => "paypal"
    #   }
    # })
    request.body = JSON.dump({
      "name" => "Override Agreement",
      "description" => "PayPal payment agreement that overrides merchant preferences and shipping fee and tax information.",
      "start_date" => start_date.strftime("%FT%T%:z"),
      "payer" => {
        "payment_method" => "paypal",
        "payer_info" => {
          "email" => "payer@example.com"
        }
      },
      "plan" => {
        "id" => plan_id
      },
      "shipping_address" => {
        "line1" => "Hotel Staybridge",
        "line2" => "Crooke Street",
        "city" => "San Jose",
        "state" => "CA",
        "postal_code" => "95112",
        "country_code" => "US"
      },
      "override_merchant_preferences" => {
        "setup_fee" => {
          "value" => "3",
          "currency" => "MXN"
        },
        "return_url" => "http://localhost:3000/active_confirmation",
        "cancel_url" => "https://example.com/cancel",
        "auto_bill_amount" => "YES",
        "initial_fail_amount_action" => "CONTINUE",
        "max_fail_attempts" => "11"
      }
    })
    response = http.request(request)
    
    begin
      response = JSON.parse(response.body)
    rescue => exception
      response = JSON.parse(eval(response.body))
    end
    return response
  end
end