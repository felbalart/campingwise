class ApplicationController < ActionController::Base
  before_action :set_raven_context

  def test_email
    ApplicationMailer.with(user: @user).test_email.deliver_now
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_admin_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
