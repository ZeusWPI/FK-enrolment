set :application, 'FK-Enrolment'
set :repo_url, 'git@github.com:ZeusWPI/FK-enrolment.git'

set :branch, 'master'
set :deploy_to, '/home/fk-enrolment/production'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
 set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/initializers/secret_token.rb config/initializers/paperclip.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system tmp/sessions}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'delayed_job:restart'
  end

  after :publishing, :restart
end

namespace :passenger do
  desc "Restart Application"
  task :restart do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        execute "touch #{current_path}/tmp/restart.txt"
      end
    end
  end
end

after :deploy, "passenger:restart"
