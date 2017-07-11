module Pipey
  class Ignore < Module
    class << self
      alias [] new
    end

    def initialize(ignore)
      # @override Pipey::Chain#valid_pipe_result?
      # @override Pipey::Line#valid_pipe_result?
      define_method :valid_pipe_result? do |result|
        super(result) && !(result === ignore)
      end
    end
  end

  IgnoreNil = Ignore.new(nil)
end
