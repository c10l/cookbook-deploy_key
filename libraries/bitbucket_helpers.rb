module BitbucketHelpers
  def auth
    { 
      :headers => {
        "User-Agent" => "Chef Deploy Key"
      },
      :basic_auth => {
        username: new_resource.credentials[:user],
        password: new_resource.credentials[:password]
      }
    }
  end

  def url; "https://bitbucket.org/api/1.0/repositories/#{new_resource.repo}/deploy-keys"; end

  def add_key(label, key)
    options = auth.merge({ :body => { :label => label, :key => key }.to_json })
    HTTParty.post(url, options)
  end

  def remove_key(label)
    key = get_key(label)
    HTTParty.delete("#{url}/#{key["pk"]}", auth) if key
  end

  def get_key(label)
    keys = HTTParty.get(url, auth)
    keys.find { |k| k["label"] == label }
  end
end
