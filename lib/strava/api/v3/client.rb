require 'strava/api/v3/activity'
require 'strava/api/v3/athlete'
require 'strava/api/v3/club'
require 'strava/api/v3/gear'
require 'strava/api/v3/segment'
require 'strava/api/v3/segment_effort'
require 'strava/api/v3/stream'

module Strava::Api::V3

  class Client

    include Activity
    include Athlete
    include Club
    include Gear
    include Segment
    include SegmentEffort
    include Stream

    # Define the same set of accessors as the Awesome module
    attr_accessor *Configuration::VALID_CONFIG_KEYS

    def initialize(options={})
      # Merge the config values from the module and those passed
      # to the client.
      merged_options = Strava::Api::V3.options.merge(options)

      # Copy the merged values to this client and ignore those
      # not part of our configuration
      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end

      @logger = options[:logger] || Logger.new(STDOUT)
      @logger.debug "Access Token: #{self.access_token}"
    end

  end # Client

end
