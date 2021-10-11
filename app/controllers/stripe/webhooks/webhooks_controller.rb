class Stripe::Webhooks::WebhooksController < ActionController::Base
  include OrdersHelper
  skip_before_action :verify_authenticity_token

  def handler
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    endpoint_secret = "whsec_kyCoJkA5Lz61Bi7nmhAZqYleE2xaNJV9" #only for local tests, every session the code will be refreshed

    begin
        event = Stripe::Webhook.construct_event(
            payload, sig_header, endpoint_secret
        )
    rescue JSON::ParserError => e
        # Invalid payload
        head :bad_request
        return
    rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        head :bad_request
        return
    end

    # Handle the event

    case event.type
    when 'payment_intent.succeeded'
      payment_intent_object = event.data.object # contains a Stripe::PaymentIntent
      puts 'PaymentIntent was successful!'
      update_order_after_payment(payment_intent_object)
    # ... handle other event types
    else
      # Unexpected event type
      head :bad_request
      return
    end

    head :ok
  end
end