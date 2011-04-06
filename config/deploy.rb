set :default_stage, "development"
set :stages, %w(production development)
require 'capistrano/ext/multistage'

default_run_options[:pty] = true # Must be set for the password prompt from git to work
ssh_options[:forward_agent] = true

set :application, "vinyl-guide"
set :repository, "git@github.com:willsu/vinyl-guide.git"

set :gem_home, "/Users/will/.rvm/gems/ruby-1.8.7-p334"

set(:rake) { "GEM_HOME=#{gem_home} RAILS_ENV=development /usr/bin/env rake" }

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
#set :deploy_to, "/home/will/workspace/cap_test/#{application}"

set :scm, :git

set :branch, "master"
set :scm_verbose, true

set :deploy_via, :remote_cache

before 'deploy:restart', 'deploy:create_conf_symlinks'
before 'deploy:restart', 'deploy:create_image_symlinks'
before 'deploy:restart', 'deploy:start_solr'
#before 'deploy:restart', 'deploy:create_solr_symlink'

namespace :deploy do

  desc "Symlink config files"
  task :create_conf_symlinks, :roles => [:app, :web, :db] do
    run "ln -s #{shared_path}/system/config/database.yml #{release_path}/config/database.yml "
    # use development/production according to environment
    run "ln -s #{shared_path}/system/config/build.development.yml #{release_path}/config/build.development.yml"
  end

  desc "Symlink image files"
  task :create_image_symlinks, :roles => [:app, :web, :db] do
    run "ln -s #{shared_path}/system/vinylguide_store/gallery #{release_path}/public/images/gallery"
    run "ln -s #{shared_path}/system/vinylguide_store/pictures #{release_path}/public/images/pictures"
  end

  #symlink to solr dir
#  desc "Symlink solr data dir"
#  task :create_solr_symlink, :roles => [:app, :web, :db] do
#    run "ln -s #{PROPERTIES['solr_home_path']} #{release_path}/solr/data"
#  end

  desc "start solr"
  task :start_solr, :roles => [:app, :web, :db] do
    run "cd #{current_path} && #{rake} sunspot:solr:stop"
    run "cd #{current_path} && #{rake} sunspot:solr:start"
  end

  task :start, :roles => :app do
    run "/opt/nginx/sbin/nginx"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "kill -HUP `cat /opt/nginx/logs/nginx.pid`"
  end
end