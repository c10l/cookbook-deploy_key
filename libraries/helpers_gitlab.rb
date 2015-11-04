module DeployKeyCookbook
  module Helpers
    module Gitlab
      def url(path = '')
        URI.parse("#{new_resource.api_url}/api/v3/projects/#{new_resource.repo}/keys#{path}")
      end

      def add_token(request)
        request.add_field "PRIVATE-TOKEN", new_resource.credentials[:token]
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
