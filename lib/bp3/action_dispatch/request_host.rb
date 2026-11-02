# frozen_string_literal: true

module Bp3
  module ActionDispatch
    module RequestHost
      def normalized_host
        host
      end
    end
  end
end
