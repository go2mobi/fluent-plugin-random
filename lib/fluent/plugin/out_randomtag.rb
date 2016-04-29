# coding: utf-8
require "securerandom"

module Fluent
  class RandomTagOutput < Output
    include Fluent::HandleTagNameMixin

    Fluent::Plugin.register_output('randomtag', self)

    config_param :integer, :string, :default => nil


    def parse_integer_field(interval)
      lower_upper = interval.split("..", 2).map{|value| Integer(value) }
      if (lower_upper.length != 2 || !lower_upper[0].is_a?(Integer) || !lower_upper[1].is_a?(Integer))
        raise "random_tag: Bad value for 'integer' (value: '#{interval}')"
      end
      return lower_upper
    end

    def check_valid_interval(lower, upper)
      if (lower >= upper)
        raise "random_tag: Bad interval for 'integer' (#{lower} >= #{upper})"
      end
    end


    def configure(conf)
      super

      if (integer.nil?)
        raise ConfigError, "random_tag: 'integer' is required to be set."
      end

      @integer_interval = parse_integer_field(integer)
      check_valid_interval(@integer_interval[0], @integer_interval[1])
      @random  = Random.new()
    end

    def emit(tag, es, chain)
      es.each { |time, record|
        t = tag.dup
        r = process()
        #Create new tag with random number prefixed
        nT = "#{r}.#{t}"
        filter_record(nT, time, record)
        Engine.emit(nT, time, record)
      }

      chain.next
    end

    private

    def filter_record(tag, time, record)
      super(tag, time, record)
    end

    def process()
      
      return generate_integer(@integer_interval[0], @integer_interval[1])
    end

    def generate_integer(lower, upper)
      return @random.rand(lower..upper)
    end

  end
end