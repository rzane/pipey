module Pipey
  module DSL
    def steps
      @steps ||= []
    end

    def steps_for(_)
      steps
    end

    def step(key)
      steps << key
    end
  end
end
