module Pipey
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
