require "faraday_middleware/cookiejar/version"

module FaradayMiddleware
  class CookieJar < ::Faraday::Middleware
    dependency 'cookiejar'

    def initialize(app, jar = ::CookieJar::Jar.new)
      super app
      @cookiejar = jar
    end

    def call(env)
      hdr = @cookiejar.get_cookie_header env[:url]
      if not hdr.empty?
        env[:request_headers]['cookie'] = hdr
      end

      @app.call(env).on_complete do
        if env[:response_headers].has_key? 'set-cookie'
          @cookiejar.set_cookie env[:url], env[:response_headers]['set-cookie']
        end
      end
    end
  end
  Faraday.register_middleware :cookie_jar => CookieJar
end
