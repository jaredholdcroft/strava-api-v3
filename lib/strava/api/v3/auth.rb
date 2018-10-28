require 'httmultiparty'

module Strava::Api::V3
  class Auth
    # Refresh user access token
    #
    # See {http://strava.github.io/api/v3/oauth} for full details
    #
    # @param client_id
    # @param client_secret
    # @param options
    #
    # @return see https://developers.strava.com/docs/authentication/)
    def self.oauth_token(client_id, client_secret, options = {})
      args = {
        client_id: client_id,
        client_secret: client_secret,
      }.merge(options)

      response = HTTMultiParty.public_send(
        'post',
        Strava::Api::V3::Configuration::DEFAULT_AUTH_ENDPOINT,
        query: args
      )

      raise Strava::Api::V3::ServerError.new(response.code.to_i, response.body) unless response.success?

      response
    end

    # Fetch user access token
    #
    # See {https://developers.strava.com/docs/authentication/} for full details
    #
    # @param client_id
    # @param client_secret
    # @param code
    # @param grant_type
    #
    # @return access_token, refresh token, token expiration + athlete json
    def self.retrieve_access(client_id, client_secret, code, grant_type = 'authorization_code')
      args = {}
      args[:code] = code
      args[:grant_type] = grant_type if grant_type
      oauth_token(client_id, client_secret, args)
    end

    # Refresh user access token
    #
    # See {https://developers.strava.com/docs/authentication/} for full details
    #
    # @param client_id
    # @param client_secret
    # @param refresh_token
    # @param grant_type
    #
    # @return refreshed access_token, new refresh token, token expiration
    def self.refresh_access_token(client_id, client_secret, refresh_token, grant_type = 'refresh_token')
      args = {}
      args[:refresh_token] = refresh_token
      args[:grant_type] = grant_type if grant_type
      oauth_token(client_id, client_secret, args)
    end
  end
end
