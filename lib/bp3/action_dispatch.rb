# frozen_string_literal: true

require 'bp3/action_dispatch/railtie'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/inflector'

module Bp3
  module ActionDispatch
    mattr_writer :site_class_name

    def self.site_class
      puts 'Bp3'.constantize
      @@site_class ||= @@site_class_name.constantize
    end
  end
end

