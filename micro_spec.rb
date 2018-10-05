# frozen_string_literal: true

require 'json'

module MicroSpec
  TestPass = Class.new(StandardError)

  def self.describe(constant, &block)
    $spec_queue = Queue.new

    Object.class_eval(
      <<~BODY
        def described_class
          #{constant}
        end

        def it(spec_name, &block)
          $spec_name = spec_name
          begin
            block.call
            puts "Test '\#{$spec_name}' passed."
          rescue Assertion::Failure => e
            failure_info = JSON.parse(e.message)
            $spec_queue << Test.new(
              name: $spec_name,
              status: 'failed',
              expect: failure_info['expect'],
              got: failure_info['got']
            )
          end
        end

        def expect(value)
          Assertion.new(value)
        end
        alias eq expect
      BODY
    )

    printer = Thread.new do
      loop do
        break if $spec_finished && $spec_queue.empty?
        test = $spec_queue.pop
        puts "Test '#{test.name}' failed."
        puts "\tExpected: #{test.expect}, Got: #{test.got}"
      end
    end

    block.call

    $spec_finished = true
    printer.join
    $spec_name = nil
    $spec_queue = nil
  end

  class Test
    attr_reader :name, :status, :expect, :got

    def initialize(name:, status:, expect:, got:)
      @name   = name
      @status = status
      @expect = expect
      @got    = got
    end
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
