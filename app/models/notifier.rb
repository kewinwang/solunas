require "digest/sha1"

class Notifier < ActionMailer::Base

  def signup_thanks( user )
    # Email header info MUST be added here
    @recipients = user.email
    @from = User.find(1).email

    @subject = "First steps at" + User.find(1).homepage
    # Email body substitutions go here
    @body["name"] = user.name

  end

  def signup_confirmation_mail ( user )

    @recipients = user.email
    @from = User.find(1).email

    @subject = "Thank you for registering at" + User.find(1).homepage
    # Email body substitutions go here
    @body["name"] = user.name
    @body["valid_key"] = user.id

  end

  def new_password ( user,password )
    @recipients = user.email
    @from = User.find(1).email
    @subject = "New Password for" + User.find(1).homepage

    # Email body substitutions go here
    @body["name"] = user.name
    @body["password"] = password

  end

  # mails notification upon new customer creation
  # expects the following keys {:from, :to, :subject, :message}
  # refactoring note - code duplication -
  #   everything except "notification" method should be removed
  def new_customer(kwargs)
    @recipients = kwargs[:to]
    @from       = kwargs[:from]
    @subject    = kwargs[:subject]
    @body       = kwargs[:message]
  end

  def document(kwargs)
    @recipients = kwargs[:to]
    @from       = "solunas.trac@gmail.com" #kwargs[:from]
    @subject    = kwargs[:subject]
    @body       = kwargs[:message]
  end

  def notification(kwargs)
    @recipients = kwargs[:to]
    @from       = kwargs[:from]
    @subject    = kwargs[:subject]
    @body       = kwargs[:message]
  end
end
