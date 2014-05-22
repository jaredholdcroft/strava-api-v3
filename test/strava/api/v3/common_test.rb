require 'helper'

ApiClass = Class.new do
  include Strava::Api::V3::Common

  def initialize api_result: 'result'
    @api_result = api_result
  end
  def api(path, args = {}, verb = "get", options = {}, &error_checking_block)
    @api_result
  end
end

module Strava::Api::V3
  describe 'common' do
    before do
      @target = ApiClass.new

      @path = 'PATH'
      @args = {id: 1}
    end

    describe '#api_call' do
      describe 'pre_call' do
        it 'returns pre_call result' do
          expected = 'CACHE'
          pre_call = Proc.new do |path, args, verb|
            expected
          end
          actual = @target.api_call(@path, @args, 'get', {pre_call: pre_call})
          actual.must_equal expected
        end

        it 'calls api if no pre_call result' do
          pre_call = Proc.new do |path, args, verb|
          end
          actual = @target.api_call(@path, @args, 'get', {pre_call: pre_call})
          actual.must_equal 'result'
        end

        it 'calls api if no pre_call is given' do
          actual = @target.api_call(@path, @args, 'get', {})
          actual.must_equal 'result'
        end
      end

      describe 'post_call' do
        it 'with no post_call' do
          actual = @target.api_call(@path, @args, 'get', {})
          actual.must_equal 'result'
        end

        it 'calls post_call with result' do
          post_call = Minitest::Mock.new
          post_call.expect(:nil?, false)
          post_call.expect(:call, nil, ['result', {path: @path, args: @args, verb: 'get'}])

          actual = @target.api_call(@path, @args, 'get', {post_call: post_call})
          post_call.verify
        end
      end
    end

    describe '#sanitize_request_parameters' do
      it 'converts Time objects to seconds' do
        time = Time.now
        sanitized = @target.sanitize_request_parameters from: time
        sanitized.must_equal from: time.to_i
      end

      it 'converts DateTime objects to seconds' do
        now = DateTime.now
        sanitized = @target.sanitize_request_parameters from: now
        sanitized.must_equal from: now.to_time.to_i
      end
    end
  end
end