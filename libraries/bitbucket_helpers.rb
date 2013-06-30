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
    options = auth.merge({ :body => { :label => label, :key => key } })
    response = HTTParty.post(url, options)
    unless response.code == 200
      raise "Could not add SSH key #{new_resource.label} to Bitbucket: #{response.code} #{response.body}"
    end
    response
  end

  def remove_key(key)
    key = get_key(key)
    response = HTTParty.delete("#{url}/#{key["pk"]}", auth) if key
    unless response.code == 204
      throw "Could not remove SSH key #{new_resource.label} from Bitbucket: #{response.code} #{response.body}"
    end
    response
  end

  def get_key(key)
    response = HTTParty.get(url, auth)
    unless response.code == 200
      throw "Could not get list of keys from Bitbucket: #{response.code} #{response.body}"
    end
    keys = response.parsed_response
    keys.find { |k| k["key"] == key }
  end
end
