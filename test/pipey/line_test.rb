require 'test_helper'

module Pipey
  class LineTest < Minitest::Test
    class Subject < Pipey::Line
      def run_multiply(num, **)
        num * 10
      end

      def run_divide(num, **)
        num / 5
      end

      class DSL < self
        extend Pipey::DSL

        step :run_multiply
        step :run_divide
      end

      class Scanner < self
        extend Pipey::Scanner[/^run_/]
      end
    end

    class MultiArg < Pipey::Line
      extend Pipey::Scanner[/^run_/]
      extend Pipey::RequiredKeys

      def run_one(input, multiply_by:, **)
        input * multiply_by
      end

      def run_two(input, divide_by:, **)
        input / divide_by
      end
    end

    class Done < Pipey::Chain
      extend Pipey::Scanner[/^run_/]

      def run_done(_, **)
        done! 100
        200
      end
    end

    def test_line_with_dsl
      assert_equal [:run_multiply, :run_divide], Subject::DSL.steps
      assert_equal 2, Subject::DSL.call(1)
    end

    def test_line_with_scanner
      assert_equal [:run_multiply, :run_divide], Subject::Scanner.steps
      assert_equal 2, Subject::Scanner.call(1)
    end

    def test_multi_arg
      assert_equal 2,  MultiArg.call(1, multiply_by: 10, divide_by: 5)
      assert_equal 10, MultiArg.call(1, multiply_by: 10)
    end

    def test_done
      assert_equal 100, Done.call(1)
    end
  end
end
