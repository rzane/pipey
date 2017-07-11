module Pipey
  module Extensions
    module RequiredKeys
      # @override Pipey::DSL.steps_for
      # @override Pipey::Scanner.steps_for
      def steps_for(params)
        super.reject do |step|
          instance_method(step).parameters.any? do |type, name|
            type == :keyreq && params[name].nil?
          end
        end
      end
    end

    class Ignore < Module
      class << self
        alias [] new
      end

      def initialize(&comparator)
        # @override Pipey::Chain#valid_pipe_result?
        # @override Pipey::Line#valid_pipe_result?
        define_method :valid_pipe_result? do |result|
          super(result) && !comparator.call(result)
        end
      end
    end

    IgnoreNil = Ignore.new(&:nil?)
  end
end
