# frozen_string_literal: true

require 'json'
require 'colorize'

module MicroSpec
  TestPass = Class.new(StandardError)

  def self.describe(constant, &block)
    Object.class_eval(
      <<~BODY
        def described_class
          #{constant}
        end

        def it(spec_name, &block)
          $spec_name = spec_name
          begin
            block.call
            puts "  It '\#{$spec_name}' passed.".colorize(:green)
          rescue Assertion::Failure => e
            failure = JSON.parse(e.message)
            puts "  It '\#{$spec_name}' failed:".colorize(:red)
            print "    Expected: \#{failure['expect'].colorize(:yellow)}, "
            puts "Got: \#{failure['got'].colorize(:yellow)}"
          end
        end

        def expect(value)
          Assertion.new(value)
        end
        alias eq expect
      BODY
    )

    puts 'Running tests:'
    block.call

    $spec_name = nil
  end

  class Assertion
    Failure = Class.new(StandardError)

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to(assertion_object)
      if @data != assertion_object.data
        data = {
          expect: @data,
          got:    assertion_object.data
        }
        raise Failure, JSON.dump(data)
      end
    end
  end
end
