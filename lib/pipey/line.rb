module Pipey
  class Line
    def self.call(*args)
      new.call(*args)
    end

    def self.valid_pipe_result?(_)
      true
    end

    def call(initial, opts = {})
      self.class.steps_for(opts).reduce(initial) do |value, name|
        result = send(name, value, opts)

        if self.class.valid_pipe_result?(result)
          result
        else
          value
        end
      end
    end
  end
end
