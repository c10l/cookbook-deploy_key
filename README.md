# deploy_key cookbook

This is a Chef cookbook to manage deploy_keys on SaaS VCSs. Currently, it supports Bitbucket and Github.

This work is heavily based on the ideas and code of ZippyKid's [github-deploy-key](https://github.com/zippykid/chef-github-deploy-key) cookbook.

# Usage

Use this cookbook as a dependency of whatever cookbook will manage your deploy keys.

Declare a `deploy_key` resource and configure the provider:

    deploy_key "app_deploy_key" do
      provider Chef::Provider::DeployKeyGithub
      ...
    end

Supported providers:

* `Chef::Provider::DeployKeyGithub`
* `Chef::Provider::DeployKeyBitbucket`

# Attributes

* `label`: Usedused as both the name of the key pair files on disk and the deploy key label on the provider. Defaults to `name`;
* `path`: The directory where the private and public keys are stored
* `credentials`: The credentials used to authenticate on the API - see [below](#authentication)
* `repo`: The repository where the deploy key will be installed. Has to be in the format `username/repo_slug` (e.g.: `cassianoleal/cookbook-deploy_key`)
* `owner`: The owner of the key files on disk. Defaults to `root`
* `group`: The group of the key files on disk. Defaults to `root`
* `mode`: The mode that will be passed on to chmod. Defaults to `0600`

# Actions

* `:create` - Runs ssh-keygen to create a key pair on the designed path;
* `:delete` - Deletes the key pair from the disk;
* `:add` - Adds the public key as a deploy key for the repository;
* `:remove` - Removes the key from the list of deploy keys on the repository

# <a id="authentication"></a>Authentication

Authentication can be done either via username/password:

    deploy_key "app_deploy_key" do
      provider Chef::Provider::DeployKeyGithub
      credentials({
        :user => 'username@org.com',
        :password => 'very_secure_password'
      })
      ...
    end

or OAuth token ( [Github](http://developer.github.com/v3/oauth/) | [Bitbucket](https://confluence.atlassian.com/display/BITBUCKET/OAuth+on+Bitbucket) ):

    deploy_key "app_deploy_key" do
      provider Chef::Provider::DeployKeyGithub
      credentials({
        :token => 'awesome_and_much_more_secure_token'
      })
      ...
    end

# A full example

    deploy_key "bitbucket_key" do
      provider Chef::Provider::DeployKeyBitbucket
      path '/home/app_user/.ssh'  
      credentials({
        :token => 'my_bitbucket_oauth_token'
      })
      repo 'organization/million_dollar_app'
      owner 'deploy'
      group 'deploy'
      mode 00640
      action :add
    end

# Author

Cassiano Leal ([email](mailto:cassianoleal@gmail.com) | [twitter](http://twitter.com/cassianoleal) | [github](https://github.com/cassianoleal)) 
