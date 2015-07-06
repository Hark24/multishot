class ManageMailer < ActionMailer::Base
  default "X-MC-Track" => "opens, clicks",
          from: "info@multshot.pe"

  def user_created(user)
  	@user = user
    mail(
      subject: "Bienvenido a Multishot",
      to: "#{user.email}"
    )
  end

end
