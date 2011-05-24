# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

VinylGuide::Application.load_tasks

#require 'tasks/rails'
#require 'sunspot/rails/tasks'

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
  cp_r "lib", "build"
  cp_r "config", "build"
  cp_r "db", "build"
  cp_r "script", "build"
  cp_r "tools", "build"
  cp_r "util", "build"
  cp   "Rakefile", "build"
#  cp   "Gemfile", "build"
end

file :copy_public_files do
  mkdir "build/public"
  cp_r "public/javascripts", "build/public/javascripts"
  cp_r "public/stylesheets", "build/public/stylesheets"
  cp_r "public/about", "build/public/about"
  mkdir "build/public/images"
  sh "cp ./public/images/*.jpg ./public/images/*.png ./build/public/images"
end

task :configure do
  sh "ln -s #{Rails.root}/../vinylguide_store/gallery #{Rails.root}/public/images"
  sh "ln -s #{Rails.root}/../vinylguide_store/pictures #{Rails.root}/public/images"
end

task :clean do
  rm_r 'build'
end