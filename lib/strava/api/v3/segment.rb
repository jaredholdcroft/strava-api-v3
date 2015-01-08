require 'strava/api/v3/common'

module Strava::Api::V3
  module Segment
    include Common

    # Fetch information about a specific segment
    #
    # See {http://strava.github.io/api/v3/segments} for full details
    #
    # @param args any additional arguments
    # @param options (see #get_object)
    # @param block post processing code block
    #
    # @return segment json (see http://strava.github.io/api/v3/segments)
    def retrieve_a_segment(id, args = {}, options = {}, &block)
      # Fetches the connections for given object.
      api_call("segments/#{id}", args, 'get', options, &block)
    end

    # Fetch information about segments starred by the authenticated user
    #
    # See {http://strava.github.io/api/v3/segments} for full details
    #
    # @param args any additional arguments
    # @param options (see #get_object)
    # @param block post processing code block
    #
    # @return segment json (see http://strava.github.io/api/v3/segments)
    def list_starred_segment(args = {}, options = {}, &block)
      # Fetches the connections for given object.
      api_call('segments/starred', args, 'get', options, &block)
    end

    # Fetch information about ranking of athletes on specific segments
    #
    # See {http://strava.github.io/api/v3/segments} for full details
    #
    # @param args any additional arguments
    # @param options (see #get_object)
    # @param block post processing code block
    #
    # @return segment json (see http://strava.github.io/api/v3/segments)
    def segment_leaderboards(id, args = {}, options = {}, &block)
      # Fetches the connections for given object.
      api_call("segments/#{id}/leaderboard", args, 'get', options, &block)
    end

    # Fetch information about segments that match the provided criteria
    #
    # See {http://strava.github.io/api/v3/segments} for full details
    #
    # @param args any additional arguments
    # @param options (see #get_object)
    # @param block post processing code block
    #
    # @return segment json (see http://strava.github.io/api/v3/segments)
    def segment_explorer(args = {}, options = {}, &block)
      # Fetches the connections for given object.
      api_call('segments/explore', args, 'get', options, &block)
    end

    # Retrieve an array of segment efforts, for a given segment, filtered by athlete and/or a date range
    #
    # See {http://strava.github.io/api/v3/segments} for full details
    #
    # @param args any additional arguments
    # @param options (see #get_object)
    # @param block post processing code block
    #
    # @return segment json (see http://strava.github.io/api/v3/segments)
    def segment_list_efforts(id, args = {}, options = {}, &block)
      # Fetches the connections for given object.
      api_call("segments/#{id}/all_efforts", args, 'get', options, &block)
    end

  end
end
