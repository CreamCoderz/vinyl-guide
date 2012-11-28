set :default_stage, "development"
set :stages, %w(production development)
require 'capistrano/ext/multistage'

default_run_options[:pty] = true # Must be set for the password prompt from git to work
ssh_options[:forward_agent] = true

set :application, "vinyl-guide"
set :repository, "git@github.com:willsu/vinyl-guide.git"

# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require "rvm/capistrano"

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user  # Don't use system-wide RVM


#set(:rake) { "GEM_HOME=#{gem_home} RAILS_ENV=#{rails_env} /usr/bin/env rake" }

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
#set :deploy_to, "/home/will/workspace/cap_test/#{application}"

set :scm, :git

set :branch, "master"
set :scm_verbose, true

set :deploy_via, :remote_cache

after 'deploy:finalize_update', 'deploy:create_conf_symlinks'
before 'deploy:restart', 'deploy:create_image_symlinks'
before 'deploy:restart', 'deploy:bundle_install'
before 'deploy:restart', 'deploy:start_solr'
before 'deploy:restart', 'deploy:migrate'

namespace :deploy do

  desc "Symlink config files"
  task :create_conf_symlinks, :roles => [:app, :web, :db, :util] do
    run "ln -s #{shared_path}/system/config/amazon.yml #{current_path}/config/amazon.yml"
    run "ln -s #{shared_path}/system/config/database.yml #{current_path}/config/database.yml"
    run "ln -s #{shared_path}/system/config/newrelic.yml #{current_path}/config/newrelic.yml"
    run "ln -s #{shared_path}/system/config/build.#{rails_env}.yml #{current_path}/config/build.#{rails_env}.yml"
  end

  desc "Symlink image files"
  task :create_image_symlinks, :roles => [:app, :web, :db] do
    run "ln -s #{shared_path}/system/vinylguide_store/gallery #{current_path}/public/images/gallery"
    run "ln -s #{shared_path}/system/vinylguide_store/pictures #{current_path}/public/images/pictures"
  end

  task :bundle_install, :roles => [:web, :db] do
    run "cd #{current_release}; bundle install"
  end

  desc "start solr"
  task :start_solr, :roles => [:util] do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:stop || true"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start"
  end

  desc "migrate db"
  task :migrate, :roles => [:db] do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  end

  task :start, :roles => :app do
    sudo "/opt/nginx/sbin/nginx"
  end

  task :stop, :roles => :app do
    sudo "kill `cat /opt/nginx/logs/nginx.pid`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    sudo "kill -HUP `cat /opt/nginx/logs/nginx.pid`"
  end
end