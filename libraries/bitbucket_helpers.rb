module BitbucketHelpers
  def auth; { username: new_resource.credentials[:user], password: new_resource.credentials[:password] }; end
  def url; "https://bitbucket.org/api/1.0/repositories/#{new_resource.repo}/deploy-keys"; end

  def add_key(label, key)
    options = {
      :body => { :label => label, :key => key },
      :basic_auth => auth
    }
    HTTParty.post(url, options)
  end

  def remove_key(label)
    options = { :basic_auth => auth }
    key = get_key(label)
    HTTParty.delete("#{url}/#{key["pk"]}", options) if key
  end

  def get_key(label)
    options = { :basic_auth => auth }
    keys = HTTParty.get(url, options)
    keys.find { |k| k["label"] == label }
  end
end
