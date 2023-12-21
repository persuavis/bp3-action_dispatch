# frozen_string_literal: true

require 'bp3/action_dispatch/includer'

module Bp3
  module ActionDispatch
    if defined?(Rails.env)
      class ActionDispatchRailtie < Rails::Railtie
        initializer 'bp3-action_dispatch.register' do |app|
          app.config.after_initialize do
            ::ActionDispatch::Request.send :include, Bp3::ActionDispatch::Includer
          end
        end
      end
    end
  end
end
