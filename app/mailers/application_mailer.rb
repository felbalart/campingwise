class ApplicationMailer < ActionMailer::Base
  include ApplicationHelper
  helper ApplicationHelper

  DEFAULT_FROM = ENV['DEFAULT_FROM_EMAIL']
  default from: DEFAULT_FROM
  layout 'mailer'

  def test_email
    @user = 'soy user'
    mail(to: DEFAULT_FROM, subject: 'prueba email')
  end


  def order_email
    @ord = params[:order]
    to = @ord.guest.email#[@ord.guest.email, DEFAULT_FROM].join(', ')
    subject = "#{ENV['CAMPING_NAME']} - Orden de Reserva Nº #{@ord.id}"
    mail(from: DEFAULT_FROM, to: to, subject: subject)
  end
end
