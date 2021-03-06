module Pipey
  module Steps
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

    class Scanner < Module
      class << self
        alias [] new
      end

      def initialize(pattern)
        define_method :steps do
          instance_methods.grep(pattern)
        end

        define_method :steps_for do |_|
          steps
        end
      end
    end
  end
end
