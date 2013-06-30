module GithubHelpers
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
  
  def url; "https://api.github.com/repos/#{new_resource.repo}/keys"; end

  def add_key(label, key)
    options = auth.merge({ :body => { :title => label, :key => key }.to_json })
    HTTParty.post(url, options)
  end

  def remove_key(label)
    key = get_key(label)
    HTTParty.delete("#{url}/#{key["id"]}", auth) if key
  end

  def get_key(label)
    keys = HTTParty.get(url, auth)
    keys.find { |k| k["title"] == label }
  end
end
