class ApplicationMailer < ActionMailer::Base
  include ApplicationHelper
  helper ApplicationHelper
  
  DEFAULT_FROM = ENV['DEFAULT_FROM_EMAIL']
  default from: DEFAULT_FROM
  layout 'mailer'

  def test_email
    @user = 'soy user'
    mail(to: 'holabalart@gmail.com', subject: 'prueba email')
  end


  def order_email
    @ord = params[:order]
    to = [@ord.guest.email, DEFAULT_FROM].join(', ')
    subject = "Orden de Reserva Nº #{@ord.id}"
    mail(from: DEFAULT_FROM, to: to, subject: subject)
  end
end
