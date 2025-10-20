class InvitationMailer < ApplicationMailer
  default from: 'froelichperry1@gmail.com' # Replace with your desired sender email

  def invite_email(email, invite_url)
    @invite_url = invite_url
    mail(to: email, subject: "Sup Bozo, Seventh Circle sends it's regards.")
  end
end
