# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_exebox_session',
  :secret      => '7523e840b708402929654e3e133179de7642c9eacc3b50ce08124b930e2ddf3adcf998ea2b5cbcfdbad2bfd25875ce9b1e9076972a4683b6f2ebf34a0754b703'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
