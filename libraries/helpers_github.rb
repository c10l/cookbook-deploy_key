module DeployKeyCookbook
  module Helpers
    module Github
      def url(path = '')
        URI.parse("https://api.github.com/repos/#{new_resource.repo}/keys#{path}")
      end

      def add_token(request)
        request.add_field "Authorization", "token #{new_resource.credentials[:token]}"
        request
      end

      def provider_specific_key_label
        :title
      end

      def retrieved_key_id
        "id"
      end
    end
  end
end
