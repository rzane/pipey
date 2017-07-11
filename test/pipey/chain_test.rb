require 'test_helper'

module Pipey
  class ChainTest < Minitest::Test
    class Subject < Pipey::Chain
      def do_multiply(multiply_by:, **)
        map { |v| v * multiply_by }
      end

      def do_divide(divide_by:, skip: false, **)
        map { |v| v / divide_by } unless skip
      end

      class DSL < self
        extend Pipey::DSL

        step :do_multiply
        step :do_divide
      end

      class Scanner < self
        extend Pipey::Scanner[/^do/]

        class RequiredKeys < self
          extend Pipey::RequiredKeys
        end

        class IgnoreNil < self
          extend Pipey::IgnoreNil
        end
      end
    end

    def test_line_with_dsl
      s = Subject::DSL

      assert_equal [:do_multiply, :do_divide], s.steps
      assert_equal [:do_multiply, :do_divide], s.steps_for(multiply_by: 10)

      assert_equal [2, 4], s.call([1, 2], multiply_by: 10, divide_by: 5)
    end

    def test_line_with_scanner
      s = Subject::Scanner

      assert_equal [:do_multiply, :do_divide], s.steps
      assert_equal [:do_multiply, :do_divide], s.steps_for(multiply_by: 10)

      assert_equal [2, 4], s.call([1, 2], multiply_by: 10, divide_by: 5)
    end

    def test_line_with_scanner_and_requirements
      s = Subject::Scanner::RequiredKeys

      assert_equal [:do_multiply, :do_divide], s.steps
      assert_equal [:do_multiply],             s.steps_for(multiply_by: 10)
      assert_equal [:do_divide],               s.steps_for(divide_by: 10)

      assert_equal [2, 4],   s.call([1, 2], multiply_by: 10, divide_by: 5)
      assert_equal [10, 20], s.call([1, 2], multiply_by: 10)
      assert_equal [1, 2],   s.call([5, 10], divide_by: 5)
    end

    def test_line_with_scanner_and_ignore
      s = Subject::Scanner::IgnoreNil

      assert_equal [10, 20], s.call([1, 2], multiply_by: 10, divide_by: 5, skip: true)
    end
  end
end
