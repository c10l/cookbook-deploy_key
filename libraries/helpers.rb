begin
  Gem::Specification.find_by_name('httparty')
rescue Gem::LoadError
  ::Chef::Log.info("Missing the httparty Gem.  Installing...")
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new(Gem::DependencyInstaller::DEFAULT_OPTIONS).install('httparty')
end
require 'httparty'

def auth; { username: new_resource.credentials[:user], password: new_resource.credentials[:password] }; end
def url; "https://bitbucket.org/api/1.0/repositories/#{new_resource.repo}/deploy-keys"; end

def add_key(name, key)
  options = {
    :body => { :label => name, :key => key },
    :basic_auth => auth
  }
  HTTParty.post(url, options)
end

def remove_key(name)
  options = { :basic_auth => auth }
  key = get_keys.find { |k| k["label"] == name }
  HTTParty.delete("#{url}/#{key["pk"]}", options) if key
end

def get_keys
  options = { :basic_auth => auth }
  HTTParty.get(url, options)
end

def get_key(name)
  get_keys.find { |k| k["label"] == name }
end
