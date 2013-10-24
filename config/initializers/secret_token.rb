# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
FKEnrolment::Application.config.secret_token = '#development#'

FKEnrolment::Application.config.fkbooks = 'http://www.fkgent.be/fkbooks/zeus_return_catcher/%d/%s'
FKEnrolment::Application.config.fkbooks_key = '#development#'

FKEnrolment::Application.config.fk_auth_url = 'http://fkgent.be/api_zeus.php'
FKEnrolment::Application.config.fk_auth_salt = '#development#'
FKEnrolment::Application.config.fk_auth_key = '#development#'

FKEnrolment::Application.config.isic_api_wsdl = 'http://staging-isicregistrations.guido.be/service.asmx?WSDL'
FKEnrolment::Application.config.isic_api_user = 'ISICFK'
FKEnrolment::Application.config.isic_api_password = 'h4fs836t2U1'

FKEnrolment::Application.config.fk_api_key = '#development#'
