set :default_stage, "development"
set :stages, %w(production development)
require 'capistrano/ext/multistage'

default_run_options[:pty] = true # Must be set for the password prompt from git to work
ssh_options[:forward_agent] = true

set :application, "vinyl-guide"
set :repository, "git@github.com:willsu/vinyl-guide.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
#set :deploy_to, "/home/will/workspace/cap_test/#{application}"

set :scm, :git

set :branch, "master"
set :scm_verbose, true

set :deploy_via, :remote_cache

before 'deploy:restart', 'deploy:create_conf_symlinks'
#before 'deploy:migrate', 'deploy:create_image_symlinks'

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

  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end