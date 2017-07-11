module Pipey
  class Chain < SimpleDelegator
    def self.call(initial, params = {})
      new(initial).call(params)
    end

    def self.valid_pipe_result?(_)
      true
    end

    def call(params = {})
      clone.call!(params)
    end

    def call!(params) # :nodoc:
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
