require 'httparty'
require 'multi_json'
require 'strava/api/v3/errors'

module Strava::Api::V3
  module Common
    # Make a call directly to the Strava API.
    # (See any of the other methods for example invocations.)
    #
    # @param path the Strava API path to query (no leading / needed)
    # @param args (see #get_object)
    # @param verb the type of HTTP request to make (get, post, delete, etc.)
    # @param options request-related options, currently unused
    #
    # @yield response when making a batch API call, you can pass in a block
    #        that parses the results, allowing for cleaner code.
    #        The block's return value is returned in the batch results.
    #
    # @raise [Stava::Api::V3::APIError] if Strava returns an error
    #
    # @return the result from Strava
    def api_call(path, args = {}, verb = 'get', options = {}, &post_processing)
      pre_call = options[:pre_call]
      pre_call_result = pre_call.call(path, args, verb) unless pre_call.nil?
      result = pre_call_result || api(path, args, verb, options) do |response|
        error = check_response(response.code, response.body)
        raise error if error
      end

      post_call = options[:post_call]
      post_call.call(result, {path: path, args: args, verb: verb}) unless post_call.nil?

      # now process as appropriate for the given call (get picture header, etc.)
      post_processing ? post_processing.call(result) : result
    end

    # Makes a request to the appropriate Facebook API.
    # @note You'll rarely need to call this method directly.
    #
    # @see GraphAPIMethods#graph_call
    # @see RestAPIMethods#rest_call
    #
    # @param path the server path for this request (leading / is prepended if not present)
    # @param args arguments to be sent to Facebook
    # @param verb the HTTP method to use
    # @param options request-related options, currently unused
    # @param error_checking_block a block to evaluate the response status for additional JSON-encoded errors
    #
    # @yield The response for evaluation
    #
    # @raise [Strava::Api::V3::ServerError] if Strava returns an error (response status >= 500)
    #
    # @return the body of the response from Strava
    def api(path, args = {}, verb = "get", options = {}, &error_checking_block)
      # If a access token is explicitly provided, use that
      # This is explicitly needed in batch requests so GraphCollection
      # results preserve any specific access tokens provided
      args["access_token"] ||= self.access_token ||= Strava::Api::V3::Configuration::DEFAULT_ACCESS_TOKEN

      puts args
      # Translate any arrays in the params into comma-separated strings
      args = sanitize_request_parameters(args)

      # add a leading /
      path = "/#{path}" unless path =~ /^\//

      # make the request via the provided service
      result = HTTParty.get("#{Strava::Api::V3::Configuration::DEFAULT_ENDPOINT}#{path}", :query => args)

      if result.code.to_i >= 500
        raise Strava::Api::V3::ServerError.new(result.code.to_i, result.body)
      end

      yield result if error_checking_block

      # if we want a component other than the body (e.g. redirect header for images), return that
      if component = options[:http_component]
        component == :response ? result : result.send(options[:http_component])
      else
        # parse the body as JSON and run it through the error checker (if provided)
        # Note: Facebook sometimes sends results like "true" and "false", which aren't strictly objects
        # and cause MultiJson.load to fail -- so we account for that by wrapping the result in []
        MultiJson.load("[#{result.body.to_s}]")[0]
      end
    end
    # Sanitizes Ruby objects into Strava-compatible string values.
    #
    # @param parameters a hash of parameters.
    #
    # Returns a hash in which values that are arrays of non-enumerable values
    #         (Strings, Symbols, Numbers, etc.) are turned into comma-separated strings.
    def sanitize_request_parameters(parameters)
      parameters.reduce({}) do |result, (key, value)|
        # if the parameter is an array that contains non-enumerable values,
        # turn it into a comma-separated list
        # in Ruby 1.8.7, strings are enumerable, but we don't care
        if value.is_a?(Array) && value.none? {|entry| entry.is_a?(Enumerable) && !entry.is_a?(String)}
          value = value.join(",")
        end
        value = value.to_time if value.is_a? DateTime
        value = value.to_i if value.is_a? Time

        result.merge(key => value)
      end
    end

      def check_response(http_status, response_body)
        # Check for Graph API-specific errors. This returns an error of the appropriate type
        # which is immediately raised (non-batch) or added to the list of batch results (batch)
        http_status = http_status.to_i

        if http_status >= 400
          begin
            response_hash = MultiJson.load(response_body)
          rescue MultiJson::DecodeError
            response_hash = {}
          end

          if response_hash['error_code']
            # Old batch api error format. This can be removed on July 5, 2012.
            # See https://developers.facebook.com/roadmap/#graph-batch-api-exception-format
            error_info = {
              'code' => response_hash['error_code'],
              'message' => response_hash['error_description']
            }
          else
            error_info = response_hash['error'] || {}
          end

          if error_info['type'] == 'OAuthException' &&
             ( !error_info['code'] || [102, 190, 450, 452, 2500].include?(error_info['code'].to_i))

            # See: https://developers.facebook.com/docs/authentication/access-token-expiration/
            #      https://developers.facebook.com/bugs/319643234746794?browse=search_4fa075c0bd9117b20604672
            AuthenticationError.new(http_status, response_body, error_info)
          else
            ClientError.new(http_status, response_body, error_info)
          end
        end
      end
end
end