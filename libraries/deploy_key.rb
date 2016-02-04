module DeployKeyCookbook
  class DeployKey < ChefCompat::Resource
    include Helpers

    actions :create, :add, :remove, :delete
    default_action :add

    property :label, String, name_property: true
    property :path, String, required: true
    property :deploy_key_label, String, default: nil

    # For OAuth: { token: token }
    # For user/pass: { user: user, password: password }
    property :credentials, Hash, required: true

    # should be in the format: username/repo_slug (e.g.: cassianoleal/cookbook-deploy_key)
    # or an integer for GitLab (e.g.: 4)
    property :repo, [ String, Integer ], required: true, regex: /(\w+\/\w+|\d+)/

    property :owner, String, default: "root"
    property :group, String, default: "root"

    property :mode, default: 00600

    property :api_url, String, default: nil

    # Client certificate support
    property :client_cert, String, default: nil
    property :client_key, String, default: nil

    use_automatic_resource_name

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
  end
end
