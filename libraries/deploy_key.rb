# Copyright (C) 2013 Cassiano Leal
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

begin
  Gem::Specification.find_by_name('httparty')
rescue Gem::LoadError
  ::Chef::Log.info("Installing 'httparty' gem...")
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new(Gem::DependencyInstaller::DEFAULT_OPTIONS).install('httparty')
end
require 'httparty'

module DeployKey
  def url
    case self
    when Chef::Provider::DeployKeyBitbucket then "https://bitbucket.org/api/1.0/repositories/#{new_resource.repo}/deploy-keys"
    when Chef::Provider::DeployKeyGithub    then "https://api.github.com/repos/#{new_resource.repo}/keys"
    end
  end
  
  def auth
    auth = { :headers => { "User-Agent" => "Chef Deploy Key", "Content-Type" => "application/json" } }
    if new_resource.credentials[:token]
      auth.merge({ :headers => { "Authorization" => "token #{new_resource.credentials[:token]}" } })
    elsif new_resource.credentials[:user] && new_resource.credentials[:password]
      auth.merge({ :basic_auth => { username: new_resource.credentials[:user], password: new_resource.credentials[:password] } })
    else
      raise "No credentials. Need API token or username/password combination."
    end
  end

  def add_key(label, key)
    options = auth.merge({
      :body => {
        case self
        when Chef::Provider::DeployKeyBitbucket then :label
        when Chef::Provider::DeployKeyGithub    then :title
        end => "#{label} - #{node.name}",
        :key => key
      }.to_json
    })
    response = HTTParty.post(url, options)
    unless response.code == 200 or response.code == 201
      raise "Could not add SSH key #{new_resource.label} to Bitbucket: #{response.code} #{response.body}"
    end
    response
  end
  
  def remove_key(key)
    key = get_key(key)
    key_id = case self
             when Chef::Provider::DeployKeyBitbucket then key["pk"]
             when Chef::Provider::DeployKeyGithub    then key["id"]
             end
    response = HTTParty.delete("#{url}/#{key_id}", auth) if key
    unless response.code == 204
      throw "Could not remove SSH key #{new_resource.label} from repository: #{response.code} #{response.body}"
    end
    response
  end

  def get_key(key)
    response = HTTParty.get(url, auth)
    unless response.code == 200 or response.code == 201
      throw "Could not get list of keys from repository: #{response.code} #{response.body}"
    end
    keys = response.parsed_response
    keys.find { |k| k["key"].strip == key.strip }
  end
end
