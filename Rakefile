# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

ENVIRONMENT = Rails.env.downcase
PROPERTIES = YAML.load_file("config/build.#{ENVIRONMENT}.yml")
BASE_PATH = PROPERTIES['base_path']

task :build => [:make_build_dirs, :copy_app_files]

task :make_build_dirs do
  rm_rf 'build'
  mkdir 'build'
end

file :copy_app_files => [:copy_public_files] do |t|
  cp_r "app", "build"
  cp_r "config", "build"
  cp_r "db", "build"
  cp_r "script", "build"
  cp_r "tools", "build"
end

file :copy_public_files do
  mkdir "build/public"
  cp_r "public/javascripts", "build/public/javascripts"
  cp_r "public/stylesheets", "build/public/stylesheets"
  mkdir "build/public/images"
  sh "cp ./public/images/*.jpg ./public/images/*.png ./build/public/images"
  sh "ln -s #{BASE_PATH}/../vinylguide_store/gallery build/public/images/gallery"
  sh "ln -s #{BASE_PATH}/../vinylguide_store/pictures build/public/images/pictures"
end

#TODO: use for deploy task
task :rotate_log_files do

end

task :clean do
  rm_r 'build'
end