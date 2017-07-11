module Pipey
  module Core
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def valid_pipe_result?(_)
        true
      end
    end

    def done!(*args)
      throw(:__pipey_done, *args)
    end

    def call(*args)
      catch :__pipey_done do
        clone.call!(*args)
      end
    end
  end
end
