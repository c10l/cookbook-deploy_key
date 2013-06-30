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
    response = HTTParty.post(url, options)
    unless response.code == 201
      raise "Could not add SSH key #{new_resource.label} to Github: #{response.body}"
    end
    response
  end

  def remove_key(key)
    key = get_key(key)
    response = HTTParty.delete("#{url}/#{key["id"]}", auth) if key
    unless response.code == 204
      throw "Could not remove SSH key #{new_resource.label} from Github: #{response.body}"
    end
    response
  end

  def get_key(key)
    keys = HTTParty.get(url, auth)
    unless keys.code == 200
      throw "Could not get list of keys from Github: #{keys.code}"
    end
    keys.find { |k| k["key"] == key }
  end
end
