require 'rake'
require 'spec/rake/spectask'

desc "Run all all tests"
Spec::Rake::SpecTask.new('all tests') do |t|
  t.spec_files = FileList['spec/*.rb']
end