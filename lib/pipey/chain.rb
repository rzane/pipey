require 'pipey/core'

module Pipey
  class Chain < SimpleDelegator
    include Core

    def self.call(initial, params = {})
      new(initial).call(params)
    end

    def call!(params = {}) # :nodoc:
      self.class.steps_for(params).each do |name|
        result = send(name, params)

        if self.class.valid_pipe_result?(result)
          __setobj__(result)
        end
      end

      __getobj__
    end
  end
end
