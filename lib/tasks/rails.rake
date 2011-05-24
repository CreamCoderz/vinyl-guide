#always invoke db:seed after the db is prepared
namespace :db do
  namespace :test do
    task :prepare => :environment do
      Rake::Task["db:seed"].invoke
    end
  end
end