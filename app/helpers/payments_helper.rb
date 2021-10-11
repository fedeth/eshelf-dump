module PaymentsHelper

  def order_is_valid?(payment_intent_id, order_id)
    payment = Payment.find_by_payment_intent_id(payment_intent_id)
    return payment.present? && payment.order.id == order_id.to_i
  end
end