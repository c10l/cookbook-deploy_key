# https://github.com/cassianoleal/cookbook-deploy_key/issues/10

directory "/test/issues/10" do
  recursive true
end

deploy_key "ads_dev-chef-ads1_deploy_key" do
  provider Chef::Provider::DeployKeyBitbucket
  path '/test/issues/10'
  mode '0640'
  action :create
end
