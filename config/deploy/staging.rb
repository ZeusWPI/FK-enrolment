server 'king.ugent.be', user: 'fk-enrolment', roles: %w{web app db},
  ssh_options: {
  forward_agent: true,
  auth_methods: ['publickey'],
  port: 2222
}

set :branch, 'fix/some-webcam-assets'

set :rails_env, 'staging'
