# frozen_string_literal: true

require 'net/http'
require 'singleton'

class JWKClient
  include Singleton

  JWKClientError = Class.new(StandardError)
  JWKClientFetchError = Class.new(JWKClientError)

  attr_reader :jwks

  def initialize
    raise JWKClientError, 'JWK endpoint is not configured' unless jwk_endpoint

    @jwks = JWT::JWK::Set.new
    @last_fetch_time = nil
    @mutex = Mutex.new
  end

  def call(options = {})
    @mutex.synchronize do
      fetch_keys if should_fetch_keys?(options)
      jwks
    end
  end

  def self.clear_cache!
    instance.clear_cache!
  end

  def clear_cache!
    @mutex.synchronize do
      @jwks = JWT::JWK::Set.new
      @last_fetch_time = nil
    end
  end

  private

  def should_fetch_keys?(options)
    jwks.keys.empty? || (options[:kid_not_found] && time_to_refresh_has_passed?)
  end

  def time_to_refresh_has_passed?
    refresh_interval = ENV.fetch('COGNITO_JWK_REFRESH_INTERVAL', 3600).to_i
    (@last_fetch_time && Time.now - @last_fetch_time) > refresh_interval
  end

  def fetch_keys
    uri = URI(jwk_endpoint)
    response = Net::HTTP.get_response(uri)
    unless response.code == "200"
      raise JWKClientFetchError, "Error fetching JWKS, "\
        "status: #{response.code}, "\
        "body: #{response.body}"
    end

    key_hash = response.body.is_a?(String) ? JSON.parse(response.body) : response.body
    @jwks = JWT::JWK::Set.new(key_hash['keys'])
    @last_fetch_time = Time.now
    @jwks
  end

  def jwk_endpoint
    ENV['COGNITO_JWK_ENDPOINT']
  end
end
