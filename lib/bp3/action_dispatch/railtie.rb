# frozen_string_literal: true

module Bp3
  module ActionDispatch
    if defined?(Rails.env)
      class Railtie < Rails::Railtie
        initializer 'bp3.action_dispatch.railtie.register' do |app|
          app.config.after_initialize do
            ::ActionDispatch::Request # preload
            module ::ActionDispatch
              class Request
                include Bp3::ActionDispatch::RequestHost
                include Bp3::ActionDispatch::RequestSite
                include Bp3::ActionDispatch::RequestLocale
              end
            end
          end
        end
      end
    end
  end
end
