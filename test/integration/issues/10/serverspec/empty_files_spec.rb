require 'serverspec'

# Required by serverspec
set :backend, :exec

describe "deploy_key" do
  context 'action :create' do
    context file('/test/issues/10/ads_dev-chef-ads1_deploy_key') do
      it { should be_file }
      its(:content) { should match(/^-----BEGIN RSA PRIVATE KEY-----$/) }
      its(:content) { should match(/^-----END RSA PRIVATE KEY-----$/) }
    end

    context file('/test/issues/10/ads_dev-chef-ads1_deploy_key.pub') do
      it { should be_file }
      its(:content) { should match(/^ssh-rsa/) }
    end
  end
end
