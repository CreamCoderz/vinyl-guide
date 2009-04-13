# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vinylguide3_session',
  :secret      => '3dd4a2ee3e85e27100da8329c713b2b4ad0fd19e67b5787403f796af4523fb47cb20a1f79c580ce78975a2c558c1a953c9af98022467acec3a3a352ba08ac7f7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
