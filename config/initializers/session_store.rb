# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_migration_to_2.3_session',
  :secret      => '484242535c052d18cdd737808ef56d1d13af365928b6a62908cf650d2fb71e068d311686c99e78275559b2cf14220ed0e2258cc923bd40453a196bc17fc3ad2c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
