# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
FKEnrolment::Application.config.secret_token = '#development#'

FKEnrolment::Application.config.fkbooks = 'http://www.fkgent.be/fkbooks/zeus_return_catcher/%d/%s'
FKEnrolment::Application.config.fkbooks_key = '#development#'
FKEnrolment::Application.config.zeus_api_salt = '#development#'
FKEnrolment::Application.config.zeus_api_key = '#development#'
FKEnrolment::Application.config.isic_pass = 'dev'
FKEnrolment::Application.config.isic_user = 'dev'
