namespace :bootstrap do
  desc "Add the default formats"
  task :default_formats => :environment do
    Format.create(:name => "LP")
    Format.create(:name => "EP")
    Format.create(:name => "Single")
  end
end