# frozen_string_literal: true

require 'bp3/action_dispatch/railtie'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/inflector'

require_relative 'action_dispatch/request_host'
require_relative 'action_dispatch/request_locale'
require_relative 'action_dispatch/request_site'
require_relative 'action_dispatch/railtie'
require_relative 'action_dispatch/version'

module Bp3
  module ActionDispatch
    mattr_accessor :site_class_name

    def self.site_class
      @@site_class ||= site_class_name.constantize # rubocop:disable Style/ClassVars
    end
  end
end
