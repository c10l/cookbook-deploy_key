if defined?(ChefSpec)

  def create_deploy_key_bitbucket(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_bitbucket, :create, resource_name)
  end
  
  def delete_deploy_key_bitbucket(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_bitbucket, :delete, resource_name)
  end

  def add_deploy_key_bitbucket(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_bitbucket, :add, resource_name)
  end

  def remove_deploy_key_bitbucket(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_bitbucket, :remove, resource_name)
  end

  def create_deploy_key_github(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_github, :create, resource_name)
  end
  
  def delete_deploy_key_github(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_github, :delete, resource_name)
  end

  def add_deploy_key_github(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_github, :add, resource_name)
  end

  def remove_deploy_key_github(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_github, :remove, resource_name)
  end

  def create_deploy_key_gitlab(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_gitlab, :create, resource_name)
  end
  
  def delete_deploy_key_gitlab(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_gitlab, :delete, resource_name)
  end

  def add_deploy_key_gitlab(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_gitlab, :add, resource_name)
  end

  def remove_deploy_key_gitlab(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:deploy_key_gitlab, :remove, resource_name)
  end

end