require 'active_support/concern'
require 'rails/rack/logger'

module Rails
  module Rack
    # Overwrites defaults of Rails::Rack::Logger that cause
    # unnecessary logging.
    # This effectively removes the log lines from the log
    # that say:
    # Started GET / for 192.168.2.1...
    class Logger
      # Overwrites Rails 3.2 code that logs new requests
      def call_app(request, env)
        # we still want the 'Started' message (so we are monkey-patching a monkey-patch)
        # original implementation:
        # http://api.rubyonrails.org/classes/Rails/Rack/Logger.html#method-i-started_request_message
        #
        # TODO: format 'started' message lograge-style,
        # TODO: only log 'started' message if lograge config wants it
        logger.info { started_request_message(request) }
        @app.call(env)
      ensure
        ActiveSupport::LogSubscriber.flush_all!
      end

      # Overwrites Rails 3.0/3.1 code that logs new requests
      def before_dispatch(_env)
      end
    end
  end
end
