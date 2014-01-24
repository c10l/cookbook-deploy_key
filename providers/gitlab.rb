# Copyright (C) 2014 David Radcliffe
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

include ::DeployKey

def whyrun_supported?
  true
end

use_inline_resources

action :create do
  if ::File.exists?("#{new_resource.path}/#{new_resource.label}") \
  and ::File.exists?("#{new_resource.path}/#{new_resource.label}.pub")
    Chef::Log.info("Key #{new_resource.path}/#{new_resource.label} already exists - nothing to do.")
  else
    converge_by("Generate #{new_resource}") do
      execute "Generate ssh key for #{new_resource.label}" do
        creates new_resource.label
        command "ssh-keygen -t rsa -q -C '' -f '#{new_resource.path}/#{new_resource.label}' -P \"\""
      end
    end
  end

  file "#{new_resource.path}/#{new_resource.label}" do
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
  end

  file "#{new_resource.path}/#{new_resource.label}.pub" do
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
  end
end

action :delete do
  key = "#{new_resource.path}/#{new_resource.label}"

  [key, "#{key}.pub"].each do |f|
    file f do
      action :delete
    end
  end
end

action :add do
  new_resource.run_action(:create)

  pubkey = ::File.read("#{new_resource.path}/#{new_resource.label}.pub")
  if get_key(pubkey)
    Chef::Log.info("Deploy key #{new_resource.label} already added - nothing to do.")
  else
    converge_by("Register #{new_resource}") do
      add_key(new_resource.label, pubkey)
    end
  end
end

action :remove do
  pubkey = ::File.read("#{new_resource.path}/#{new_resource.label}.pub")
  if get_key(pubkey)
    converge_by("De-register #{new_resource}") do
      remove_key(pubkey)
    end
  else
    Chef::Log.info("Deploy key #{new_resource} not present - nothing to do.")
  end
end
