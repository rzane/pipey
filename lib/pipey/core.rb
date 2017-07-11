module Pipey
  module Core # :nodoc:
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def valid_pipe_result?(_)
        true
      end
    end

    def stop!(*args)
      throw(:__pipey_stop, *args)
    end

    def call(*args)
      catch :__pipey_stop do
        clone.call!(*args)
      end
    end
  end
end
