# coding: utf-8
require 'test_helper'
require 'fluent/plugin/out_randomtag'

class RandomTagOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    @p = create_driver(%[
      strict true
      integer 1..10
    ])
  end

  def create_driver(conf, tag = 'test')
    Fluent::Test::OutputTestDriver.new(
      Fluent::RandomTagOutput, tag
    ).configure(conf)
  end

  def test_unit_parse_integer
    assert_raise do @p.instance.parse_integer_field("") end
    assert_raise do @p.instance.parse_integer_field("1.10") end
    assert_raise do @p.instance.parse_integer_field("1..10,1") end
    assert_raise do @p.instance.parse_integer_field("10") end
    assert_raise do @p.instance.parse_integer_field("1..10..11") end
    assert_raise do @p.instance.parse_integer_field("1..") end
    assert_raise do @p.instance.parse_integer_field("..10") end
    assert_raise do @p.instance.parse_integer_field("foo..10") end
    assert_raise do @p.instance.parse_integer_field("1..bar") end
    assert_raise do @p.instance.parse_integer_field("foo") end
    assert_raise do @p.instance.parse_integer_field("foo..bar") end

    lower_upper = @p.instance.parse_integer_field("1..10")
    assert_equal 1, lower_upper[0]
    assert_equal 10, lower_upper[1]

    lower_upper = @p.instance.parse_integer_field("10..1")
    assert_equal 10, lower_upper[0]
    assert_equal 1, lower_upper[1]

    lower_upper = @p.instance.parse_integer_field("-10000000000..10000000000")
    assert_equal -10000000000, lower_upper[0]
    assert_equal 10000000000, lower_upper[1]

    lower_upper = @p.instance.parse_integer_field("-1000000000000000000000000000000..1000000000000000000000000000000")
    assert_equal -1000000000000000000000000000000, lower_upper[0]
    assert_equal 1000000000000000000000000000000, lower_upper[1]
  end

  def test_unit_check_valid_interval()
    assert_raise do @p.instance.check_valid_interval(10,1) end
    assert_raise do @p.instance.check_valid_interval(10,-1) end

    @p.instance.check_valid_interval(-50,10)
    @p.instance.check_valid_interval(1,10)
    @p.instance.check_valid_interval(-1000000000000000000000000000000, 1000000000000000000000000000000)
  end

  def test_configure_on_success
    # All set
    d = create_driver(%[
      strict true
      integer 1..10
    ])

  end

  def test_configure_on_failure
    # when mandatory keys not set
    assert_raise(Fluent::ConfigError) do
      create_driver(%[
        blah blah
      ])
    end


    # 'integer' is missing
    assert_raise(Fluent::ConfigError) do
      create_driver(%[
        field key1
      ])
    end
  end

  def test_emit
    d = create_driver(%[
      integer 1..10
    ])

    record = {
      'foo' => 'bar'
    }

    d.run { d.emit(record) }
    emits = d.emits

    assert_equal 1,           emits.count
    assert_equal 'bar', emits[0][2]['foo']

  end

end
