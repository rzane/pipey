# Pipey

A utility for pipeline operations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pipey'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pipey

## Usage

### `Pipey::Line`

`Pipey::Line` can be used to work with any object in a pipe-line manner.

```ruby
class MyPipe < Pipey::Line
  extend Pipey::Steps::Scanner[/^run_/]

  def run_foo(num, multiply:, **)
    num * multiply
  end

  def run_bar(num, add:, **)
    num + add
  end
end

MyPipe.call(1, multiply: 10, add: 5) #=> 15
```

### `Pipey::Chain`

`Pipey::Chain` is a slightly fancier way to work with chainable objects like `Array`s or `ActiveRecord::Relation`s.

```ruby
class MyPipe < Pipey::Chain
  extend Pipey::Steps::Scanner[/^run_/]

  def run_foo(multiply:, **)
    map { |v| v * a }
  end

  def run_bar(minimum:, **)
    select { |v| v > minimum }
  end
end

MyPipe.call([1, 2, 3], multiply: 5, minimum: 6) #=> [10, 15]
```

### `Pipey::Steps::Scanner`

`Pipey::Steps::Scanner` takes a `Regexp` as an argument, and it will run the methods that match the regexp.

**NOTE:** This does not guarantee the order in which steps will run.

### `Pipey::Steps::DSL`

If you don't like the automatic behavior provided by `Pipey::Steps::Scanner`, you can use `Pipey::Steps::DSL` instead. With it, you can list out your steps.

**NOTE:** This does guarantee the order in which steps will run.

```ruby
class MyPipe < Pipey::Line
  extend Pipey::Steps::DSL

  step :foo
  step :bar

  def foo(num, multiply:, **)
    num * multiply
  end

  def bar(num, add:, **)
    num + add
  end
end

MyPipe.call(1, multiply: 10, add: 5) #=> 15
```

### `Pipey::Extensions::RequiredKeys`

This extension won't call a step if it requires a key that is falsy.

```ruby
class MyPipe < Pipey::Line
  extend Pipey::Steps::Scanner[/^run_/]
  extend Pipey::Extensions::RequiredKeys

  def run_foo(num, multiply:, **)
    num * multiply
  end

  def run_bar(num, add:, **)
    num + add
  end
end

MyPipe.call(1, multiply: 10, add: 5) #=> 15
MyPipe.call(1, multiply: 10)         #=> 10
MyPipe.call(1, add: 5)               #=> 6
```

### `Pipey::Extensions::IgnoreNil`

By using this extension, any step that returns nil will be ignored.

```ruby
class MyPipe < Pipey::Line
  extend Pipey::Steps::Scanner[/^run_/]
  extend Pipey::Extensions::IgnoreNil

  def run_foo(num, add:, **)
    num * add if add > 5
  end
end

MyPipe.call(1, add: 5) #=> 1
MyPipe.call(1, add: 6) #=> 6
```

### `Pipey::Extensions::Ignore`

This can be used to create more complicated ignores.

For example, the implementation of `IgnoreNil` looks like this:

```ruby
Pipey::Extensions::Ignore.new(&:nil?)
```

If you wanted to ignore any value equal to 5, you could do this:

```ruby
class MyPipe < Pipey::Line
  extend Pipey::Extensions::Ignore.new { |v| v == 5 }
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rzane/pipey.
