if defined?(ChefSpec)

  def create_deploy_key(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key, :create, resource_name)
  end
  
  def delete_deploy_key(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key, :delete, resource_name)
  end

  def add_deploy_key(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key, :add, resource_name)
  end

  def remove_deploy_key(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key, :remove, resource_name)
  end

end