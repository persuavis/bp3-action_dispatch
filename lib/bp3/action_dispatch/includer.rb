# frozen_string_literal: true

require 'bp3/action_dispatch/request_host'
require 'bp3/action_dispatch/request_site'
require 'bp3/action_dispatch/request_location'

module Bp3
  module ActionDispatch
    module Includer
      include RequestHost
      include RequestSite
      include RequestLocale
    end
  end
end
