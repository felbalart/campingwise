class ApplicationController < ActionController::Base
  before_action :set_raven_context

  def test_email
    order = Order.find 31
    ApplicationMailer.with(order: order).order_email.deliver_now
    render  body: nil
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_admin_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
