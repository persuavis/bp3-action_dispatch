# frozen_string_literal: true

module Bp3
  module ActionDispatch
    module RequestSite
      def request_site
        @request_site ||= Bp3::ActionDispatch.site_class.find_host(normalized_host)
      end
    end
  end
end
