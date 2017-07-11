module Pipey
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
end
