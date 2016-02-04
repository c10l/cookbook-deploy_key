module DeployKeyCookbook
  class DeployKeyGithub < DeployKey
    include Helpers::Github

    use_automatic_resource_name
    provides :deploy_key

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
  end
end
