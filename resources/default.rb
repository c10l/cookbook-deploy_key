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

actions :create, :add, :remove, :delete
default_action :add

attribute :label, :kind_of => String, :name_attribute => true
attribute :path, :kind_of => String, :required => true

# For OAuth: { :token => token }
# For user/pass: { :user => user, :password => password }
attribute :credentials, :kind_of => Hash, :required => true

# should be in the format: username/repo_slug (e.g.: cassianoleal/cookbook-deploy_key)
# or an integer for GitLab (e.g.: 4)
attribute :repo, :kind_of => [ String, Integer ],
                 :required => true,
                 :regex => /(\w+\/\w+|\d+)/

attribute :owner, :kind_of => String, :default => "root"
attribute :group, :kind_of => String, :default => "root"

attribute :mode, :default => 00600

attribute :api_url, :kind_of => String, :default => nil
