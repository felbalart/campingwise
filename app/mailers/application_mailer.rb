class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def test_email
    @user = 'soy user'
    mail(to: 'holabalart@gmail.com', subject: 'prueba email')
  end
end
