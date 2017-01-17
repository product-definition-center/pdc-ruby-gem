require 'ap'
require 'curb'
require 'json'
require './lib/pdc'

def obtain_token
  url = PDC.config.site + PDC.config.rest_api_path + '/' + PDC.config.token_obtain_path

  c = Curl::Easy.new(url) do |request|
    request.headers['Accept'] = 'application/json'
    request.http_auth_types = :gssnegotiate

    # The curl man page (http://curl.haxx.se/docs/manpage.html) specifes
    # setting a fake username when using Negotiate auth, and use ':'
    # in their example.
    request.username = ':'
  end
  c.perform
  raise "Obtain token from #{url} failed: #{c.body_str}" if c.response_code != 200
  result = JSON.parse(c.body_str)
  ap result
  c.close
  result['token']
end

PDC.configure do |config|
  # invalid
  config.site = 'https://pdc.engineering.redhat.com/'
end

def show_releases
  releases = PDC::V1::Release.all
  ap releases.to_a
end

show_releases
