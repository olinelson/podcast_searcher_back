class NotificationMailer < ApplicationMailer
    def clip_done_email(clip)
    @user = clip.author
    @clip = clip
    mail(to: @user.email, subject: 'Processing Complete')
  end

end
