module DeployKeyCookbook
  class DeployKeyGitlab < DeployKey
    include Helpers::Gitlab

    use_automatic_resource_name
    provides :deploy_key

    action :add do
      new_resource.run_action(:create)

      pubkey = ::File.read("#{new_resource.path}/#{new_resource.label}.pub")
      if get_key(pubkey)
        Chef::Log.info("Deploy key #{new_resource.label} already added - nothing to do.")
      else
        converge_by("Register #{new_resource}") do
          label = new_resource.deploy_key_label.nil? ? new_resource.label : new_resource.deploy_key_label

          add_key(label, pubkey)
        end
      end
    end
  end
end
