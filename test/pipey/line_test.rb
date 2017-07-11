require 'test_helper'

module Pipey
  class LineTest < Minitest::Test
    class Subject < Pipey::Line
      def do_multiply(num, **)
        num * 10
      end

      def do_divide(num, **)
        num / 5
      end

      class DSL < self
        extend Pipey::DSL

        step :do_multiply
        step :do_divide
      end

      class Scanner < self
        extend Pipey::Scanner[/^do/]
      end
    end

    class MultiArg < Pipey::Line
      extend Pipey::Scanner[/^do/]
      extend Pipey::RequiredKeys

      def do_one(input, multiply_by:, **)
        input * multiply_by
      end

      def do_two(input, divide_by:, **)
        input / divide_by
      end
    end

    def test_line_with_dsl
      assert_equal [:do_multiply, :do_divide], Subject::DSL.steps
      assert_equal 2, Subject::DSL.call(1)
    end

    def test_line_with_scanner
      assert_equal [:do_multiply, :do_divide], Subject::Scanner.steps
      assert_equal 2, Subject::Scanner.call(1)
    end

    def test_multi_arg
      assert_equal 2,  MultiArg.call(1, multiply_by: 10, divide_by: 5)
      assert_equal 10, MultiArg.call(1, multiply_by: 10)
    end
  end
end
