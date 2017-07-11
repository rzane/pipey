require 'test_helper'

module Pipey
  class ChainTest < Minitest::Test
    class Subject < Pipey::Chain
      def run_multiply(multiply_by:, **)
        map { |v| v * multiply_by }
      end

      def run_divide(divide_by:, skip: false, **)
        map { |v| v / divide_by } unless skip
      end

      class DSL < self
        extend Pipey::Steps::DSL

        step :run_multiply
        step :run_divide
      end

      class Scanner < self
        extend Pipey::Steps::Scanner[/^run_/]

        class RequiredKeys < self
          extend Pipey::Extensions::RequiredKeys
        end

        class IgnoreNil < self
          extend Pipey::Extensions::IgnoreNil
        end
      end
    end

    class Stopper < Pipey::Chain
      extend Pipey::Steps::Scanner[/^run_/]

      def run_stop(**)
        stop! 100
        200
      end
    end

    def test_line_with_dsl
      s = Subject::DSL

      assert_equal [:run_multiply, :run_divide], s.steps
      assert_equal [:run_multiply, :run_divide], s.steps_for(multiply_by: 10)

      assert_equal [2, 4], s.call([1, 2], multiply_by: 10, divide_by: 5)
    end

    def test_line_with_scanner
      s = Subject::Scanner

      assert_equal [:run_multiply, :run_divide], s.steps
      assert_equal [:run_multiply, :run_divide], s.steps_for(multiply_by: 10)

      assert_equal [2, 4], s.call([1, 2], multiply_by: 10, divide_by: 5)
    end

    def test_line_with_scanner_and_requirements
      s = Subject::Scanner::RequiredKeys

      assert_equal [:run_multiply, :run_divide], s.steps
      assert_equal [:run_multiply],              s.steps_for(multiply_by: 10)
      assert_equal [:run_divide],                s.steps_for(divide_by: 10)

      assert_equal [2, 4],   s.call([1, 2], multiply_by: 10, divide_by: 5)
      assert_equal [10, 20], s.call([1, 2], multiply_by: 10)
      assert_equal [1, 2],   s.call([5, 10], divide_by: 5)
    end

    def test_line_with_scanner_and_ignore
      s = Subject::Scanner::IgnoreNil

      assert_equal [10, 20], s.call([1, 2], multiply_by: 10, divide_by: 5, skip: true)
    end

    def test_stop
      assert_equal 100, Stopper.call(1)
    end
  end
end
