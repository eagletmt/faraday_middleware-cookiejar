require 'spec_helper'

describe FaradayMiddleware::CookieJar do
  before do
    @session_id = 'deadbeef'
    @domain = '.example.com'

    @stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post '/login' do |env|
        cookie = CGI::Cookie.new 'domain' => @domain, 'name' => 'session_id', 'value' => @session_id
        [200, {'set-cookie' => cookie.to_s}, '']
      end

      stub.get '/session_id' do |env|
        body =
          if env[:request_headers].has_key? 'cookie'
            c = CGI::Cookie.parse env[:request_headers]['cookie']
            if c.has_key? 'session_id'
              c['session_id'].first
            end
          end
        [200, {}, body]
      end
    end

    @conn = Faraday::Connection.new do |builder|
      builder.use :cookie_jar, *middleware_args
      builder.adapter :test, @stubs
    end
  end

  let(:middleware_args) { [] }

  [:get, :post].each do |meth|
    define_method meth do |url|
      @conn.send(meth, url).body
    end
  end

  it 'sets cookie' do
    expect(get 'http://www.example.com/session_id').to be_nil
    post 'http://www.example.com/login'
    expect(get 'http://www.example.com/session_id').to eql @session_id
  end

  it "doesn't send cookie to another domain" do
    post 'http://www.example.com/login'
    expect(get 'http://www.example.net/session_id').to be_nil
  end

  it 'updates cookie' do
    post 'http://www.example.com/login'
    expect(get 'http://www.example.com/session_id').to eql @session_id
    @session_id = 'cafebabe'
    post 'http://www.example.com/login'
    expect(get 'http://www.example.com/session_id').to eql 'cafebabe'
  end

  context 'with CookieJar::Jar' do
    let(:cookiejar) { CookieJar::Jar.new }
    let(:middleware_args) { [cookiejar] }

    it 'stores cookies to given jar' do
      url = 'http://www.example.com/session_id'
      expect(cookiejar.get_cookies url).to be_empty
      post 'http://www.example.com/login'
      expect(cookiejar.get_cookies url).to have(1).item
    end
  end
end
