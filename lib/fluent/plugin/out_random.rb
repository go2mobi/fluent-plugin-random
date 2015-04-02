# coding: utf-8
require "securerandom"

module Fluent
  class RandomOutput < Output
    include Fluent::HandleTagNameMixin

    Fluent::Plugin.register_output('random', self)

    config_param :integer, :string, :default => nil
    config_param :field, :string, :default => nil


    def parse_integer_field(interval)
      lower_upper = interval.split("..", 2).map{|value| Integer(value) }
      if (lower_upper.length != 2 || !lower_upper[0].is_a?(Integer) || !lower_upper[1].is_a?(Integer))
        raise "random: Bad value for 'integer' (value: '#{interval}')"
      end
      return lower_upper
    end

    def check_valid_interval(lower, upper)
      if (lower >= upper)
        raise "random: Bad interval for 'integer' (#{lower} >= #{upper})"
      end
    end


    def configure(conf)
      super

      if (field.nil? || integer.nil?)
        raise ConfigError, "random: 'field' is required to be set."
      end

      if (integer.nil?)
        raise ConfigError, "random: 'integer' is required to be set."
      end

      @integer_interval = parse_integer_field(integer)
      check_valid_interval(@integer_interval[0], @integer_interval[1])
      @field = field
      @random  = Random.new()
    end

    def emit(tag, es, chain)
      es.each { |time, record|
        t = tag.dup
        filter_record(t, time, record)
        Engine.emit(t, time, record)
      }

      chain.next
    end

    private

    def filter_record(tag, time, record)
      super(tag, time, record)
      record[@field] = process()
    end

    def process()
      
      return generate_integer(@integer_interval[0], @integer_interval[1])
    end

    def generate_integer(lower, upper)
      return @random.rand(lower..upper)
    end

  end
end
