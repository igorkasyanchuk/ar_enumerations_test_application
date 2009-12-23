# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test_ar_enumerations_session',
  :secret      => '48b2306e56aa8dfa07d0cdb4b4f9b712fa405541d39325afc067ac51a9f955912ed86828d9175ca5a4adebbc1e245054e4250da2cfde221e06e2f3d5ca86ea04'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
