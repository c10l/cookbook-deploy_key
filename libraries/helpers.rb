begin
  Gem::Specification.find_by_name('httparty')
rescue Gem::LoadError
  ::Chef::Log.info("Missing the httparty Gem.  Installing...")
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new(Gem::DependencyInstaller::DEFAULT_OPTIONS).install('httparty')
end
require 'httparty'
