require 'rubygems'
require 'rake'
require 'pancake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "proxy_stack"
    gem.summary = %Q{Simple Light weight proxy}
    gem.email = "has.sox@gmail.com"
    gem.homepage = "http://github.com/hassox/proxy_stack"
    gem.authors = ["Daniel Neighman", "Lincoln Stoll"]
    gem.add_dependency "pancake", ">=0.1.25"
    gem.files = FileList["[A-Z]*", "pancake.init", "{lib,spec,rails}/**/*"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require File.join(File.dirname(__FILE__), "lib", "proxy_stack")
Pancake.root = Pancake.get_root(__FILE__, "lib", "proxy_stack")
THIS_STACK = ProxyStack
ProxyStack.load_rake_tasks!(:master => true)

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end


task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "foo #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

