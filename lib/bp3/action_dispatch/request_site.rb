# frozen_string_literal: true

# RequestSite is included in ActionDispatch::Request
# it depends on RequestHost
module RequestSite
  def request_site
    @request_site ||= Sites::Site.find_host(normalized_host)
  end
end
